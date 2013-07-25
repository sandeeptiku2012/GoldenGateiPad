//
//  VideoPlaybackViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VideoPlaybackViewController.h"

#import "Video.h"
#import "Channel.h"
#import "VimondStore.h"
#import "PlayerLayerView.h"
#import "KITTimeUtils.h"
#import "VideoProgressSlider.h"
#import "VideoPlayerTrayView.h"
#import "VideoCellView.h"
#import "ChannelCellView.h"
#import "GGBarButtonItem.h"
#import "LikeBarButton.h"
#import "FavoriteBarButtonItem.h"
#import "GGVolumeView.h"
#import "PlaybackStore.h"
#import "ProductAvailabilityService.h"
#import "Playback.h"
#import "GGBackgroundOperationQueue.h"
#import "SearchResult.h"
#import "KITGridLayoutView.h"
#import "PlayProgress.h"
#import "GGColor.h"
#import "GGUsageTracker.h"
#import "PTMediaError.h"
#import "PTMediaPlayerView.h"
#import "PTMediaPlayerNotifications.h"
#import "PrimeTimePlayer.h"
#import "PTMediaPlayerItem.h"
#import "Constants.h"


#import <AVFoundation/AVFoundation.h>

#define kNoTime @"--:--";
#define kVideoProgressUpdateInterval 1
#define kVideoTimeoutDuration 20
#define kPlaybackControlHidingInterval 7
#define kTabFadeDuration 0.2
#define kTrayTabSpacing 2
#define kVideoSwipeAnimationDuration 0.25
#define kMaxPlaylistLength 25
#define kResumePromptFadeDuration 0.3





@interface VideoPlaybackViewController ()

// UI elements
@property (weak, nonatomic) IBOutlet PlayerLayerView *playerLayerView;
@property (weak, nonatomic) IBOutlet GGVolumeView *volumeView;
@property (weak, nonatomic) IBOutlet UIView *videoControlsContainer;
@property (weak, nonatomic) IBOutlet VideoProgressSlider *videoProgressSlider;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet VideoPlayerTrayView *playlistTray;
@property (weak, nonatomic) IBOutlet VideoPlayerTrayView *myChannelsTray;
@property (weak, nonatomic) IBOutlet UIView *resumeProgressView;

@property (strong, nonatomic) TimedUserInterfaceVisibilityController *interfaceVisibilityController;

// Timers
@property (strong, nonatomic) NSTimer *videoProgressUpdateTimer;
@property (strong, nonatomic) NSTimer *videoLoadingTimeoutTimer;
@property (assign, nonatomic) NSTimeInterval currentVideoWatchDuration;

// Player related properties
@property (strong, nonatomic) PlayerPlatformAPI *player; // Viper (Prime Time) player
@property (assign) BOOL isUserDraggingSeeker; // YES when user is using progress slider.
@property (assign) BOOL isPlayerSeeking;      // YES when player is seeking
@property (assign, nonatomic) float restoreToPlaybackRate;

// Channel data
@property (strong, nonatomic) NSArray *videoList;
@property (strong, nonatomic) NSArray *channelList;

@property (strong, nonatomic) NSOperation *updateFromChannelOperation;
@property (strong, nonatomic) NSOperation *updateFromVideoOperation;
@property (strong, nonatomic) NSOperation *storeProgressOperation;

// A shared background operation queue that will not have its operations cancelled when the view disappears.
@property (strong, nonatomic) NSOperationQueue *nonInterruptedBgQueue;
@property (strong, nonatomic) PlayProgress *currentlyRestoredPlayProgress;
@property (assign) BOOL progressChanged;

@end

// Need for Viper (Prime Time) player. Implemented in library.
extern NSString* const MEDIA_ID;
extern NSString* const TP_ID;

@implementation VideoPlaybackViewController
enum
{
    kObserverKeyPathIndexStatus,
    kObserverKeyPathIndexAirPlayVideoActive,
    kObserverKeyPathIndexSeekableTimeRanges
};

+ (void)initialize
{
    //add initialize code here
}

/*!
 Show video player and make it start playing video pointed to by URL
 in \a video object.
 */
+ (void)presentVideo:(Video *)video
         fromChannel:(Channel *)channel
withNavigationController:(UINavigationController *)navigationController
{
    VideoPlaybackViewController *videoPlaybackViewController = [[VideoPlaybackViewController alloc] initWithVideo:video channel:channel];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:videoPlaybackViewController];
    [navigationController presentViewController:navController animated:YES completion:nil];
    
    if (channel == nil)
    {
        [[GGBackgroundOperationQueue sharedInstance] addOperationWithBlock:^
         {
             NSError *error = nil;
             Channel *channelForVideo = [[VimondStore channelStore] channelWithId:video.channelID error:&error];
             [[NSOperationQueue mainQueue] addOperationWithBlock:^
              {
                  videoPlaybackViewController.currentChannel = channelForVideo;
              }];
         }];
    }
}

#pragma mark - Init

- (id)initWithVideo:(Video *)video channel:(Channel *)channel
{
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]))
    {
        _currentVideo = video;
        _currentChannel = channel;
        self.interfaceVisibilityController = [[TimedUserInterfaceVisibilityController alloc] initWithInactivityTimeoutInterval:kPlaybackControlHidingInterval];
        self.interfaceVisibilityController.delegate = self;
        self.nonInterruptedBgQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}



- (void)createCloseButton
{
    self.navigationItem.leftBarButtonItem = [[GGBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CloseLKey", @"") image:nil target:self
                                                                            action:@selector(dismiss)];
}

- (void)setupTrays
{
    //    self.myChannelsTray.tabLocation = VideoPlayerTrayViewTabLocationBelow;
    self.myChannelsTray.tabLabelString = [NSLocalizedString(@"SubscriptionsLKey", @"") uppercaseString];
    self.playlistTray.tabLabelString = [NSLocalizedString(@"WatchNextLKey", @"") uppercaseString];
    self.myChannelsTray.tabIconImage = [UIImage imageNamed:@"MyChannelsIconGray.png"];
    self.playlistTray.tabIconImage = [UIImage imageNamed:@"PlaylistIcon.png"];
    self.playlistTray.fadeItemsToLeftOfActive = YES;
}

- (void)setupGestureRecognizers
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeVideoPlayer:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeVideoPlayer:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapVideoPlayer:)];
    
    [self.playerLayerView addGestureRecognizer:tapRecog];
    [self.playerLayerView addGestureRecognizer:leftSwipe];
    [self.playerLayerView addGestureRecognizer:rightSwipe];
}

- (void)setupMyChannelsList
{
    [self.myChannelsTray clearDynamicContent];
    
    self.channelList = nil;
    [self.viewControllerOperationQueue addOperationWithBlock:^
     {
         NSError *error;
         NSArray *channelArray = [[VimondStore sharedStore] myChannels:&error];
         if (error)
         {
             return;
         }
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
          {
              self.channelList = channelArray;
              for (Channel *channelTest in channelArray)
              {
                  ChannelCellView *channelCellView = [[ChannelCellView alloc] initWithCellSize:CellSizeSmall];
                  channelCellView.channel = channelTest;
                  channelCellView.animateSelection = YES;
                  [channelCellView addTarget:self action:@selector(didTapChannelCell:) forControlEvents:UIControlEventTouchUpInside];
                  [self.myChannelsTray addViewToDynamicContent:channelCellView];
              }
          }];
     }];
}

#pragma mark - UIViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Update the tab location of  the my channels tab so it's right of the playlist tab.
    CGRect frame = self.myChannelsTray.trayTabView.frame;
    frame.origin.x = self.playlistTray.trayTabView.frame.origin.x + self.playlistTray.trayTabView.frame.size.width;
    frame.origin.x += kTrayTabSpacing;
    self.myChannelsTray.trayTabView.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.loadingView.delegate = self;
    
    [self createCloseButton];
    [self resetTimeLabels];
    [self updatePlayPauseButton];
    [self setupTrays];
    [self setupGestureRecognizers];
    [self setupMyChannelsList];
    
    [self updateFromChannel:self.currentChannel];
    [self updateFromVideo:self.currentVideo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    
    [super viewDidDisappear:animated];
    [self trackWatchDurationForVideo:self.currentVideo];
    [self storeProgressForCurrentVideo];
    
    [self stopAllTimers];
    
    // Stopping Viper (Prime Time) player when view disappears
    [self.player stop];
    
    // Removing observers of Viper (Prime Time) player on view disappears
    [self removeObserversForPlayer];
    
    // Destroy Viper (Prime Time) player and assign nil
    [self.player destroy];
    self.player = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)removeObserversForPlayer
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_FAILED object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_PROGRESS object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PLAY_STATE_CHANGED object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_ENDED object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_COMPLETE object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_FAILURE object:self.player];
    
}

-(void)addObserversForPlayer
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmCompleteForPlayer:) name:DRM_COMPLETE object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmFailureForPlayer:) name:DRM_FAILURE object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerError:) name:MEDIA_FAILED object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerTimeChange:) name:MEDIA_PROGRESS object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerStateChaged:) name:PLAY_STATE_CHANGED object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaComplete:) name:MEDIA_ENDED object:self.player];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.videoProgressSlider.enabled = NO;
    [self.interfaceVisibilityController startTrackingInactivity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trayDidStartExpanding:) name:kNotificationTrayViewDidStartExpanding object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trayDidFinishContracting:) name:kNotificationTrayViewDidFinishContracting object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trayDidStartExpanding:) name:kNotificationTrayViewDidStartDragging object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trayDidFinishExpanding:) name:kNotificationTrayViewDidFinishExpanding object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
}

- (void)appEnteredBackground
{
    [self trackWatchDurationForVideo:self.currentVideo];
    [self storeProgressForCurrentVideo];
}

- (void)appEnteredForeground
{
    [self updateFromVideo:self.currentVideo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.interfaceVisibilityController startTrackingInactivity];
}

- (void)resumeProgress
{
    if (self.currentlyRestoredPlayProgress.offsetSeconds > 0 && self.progressChanged)
    {
        [self showResumeProgressPrompt];
    }
    else if(self.currentlyRestoredPlayProgress.offsetSeconds > 0 && !self.progressChanged)
    {
        [self resumeWithCurrentProgress];
    }
    else
    {
        [self hideResumeProgressPrompt];
    }
}



- (void)showAirPlayActive
{
    [self.loadingView showMessage:NSLocalizedString(@"AirPlayActiveLKey", @"")];
}

- (void)updateTimeoutTimer
{
    //TimeoutTimer is started for Viper player here. If timer reaches timer ticker value, error window is popped up.
    NSString* strStatus = self.player.getPlayerStatus;
    
    if (([strStatus isEqualToString:VIPERPL_READY])||([strStatus isEqualToString:VIPERPL_PLAYING])||([strStatus isEqualToString:VIPERPL_PAUSED])||([strStatus isEqualToString:VIPERPL_COMPLETED]))
    {
        [self stopVideoLoadingTimeoutTimer];
    }
    else
    {
        [self startVideoLoadingTimeoutTimer];
    }
    
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Factory methods

// Create Viper (Prime Time) player from URL
- (PlayerPlatformAPI *)playerForVideoURL:(NSURL *)videoURL
{

    NSMutableDictionary* contentOptions = [NSMutableDictionary new];

    if(nil==self.player)
    {
        PlayerPlatformAPI* newPlayer = [[PlayerPlatformAPI alloc]init];
        [newPlayer.getView setAutoresizingMask:( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight )];
        [newPlayer setContentURL:[videoURL absoluteString] withContentOptions:contentOptions];
        self.player = newPlayer;
        
        [self addObserversForPlayer];
    }else{
        [self.player stop];
        [self.player setContentURL:[videoURL absoluteString] withContentOptions:contentOptions];
    }
    
    return self.player;
    
}

#pragma mark - Update methods

- (void)resetTimeLabels
{
    self.leftTimeLabel.text = kNoTime;
    self.rightTimeLabel.text = kNoTime;
}

- (void)updateFromChannel:(Channel *)channel
{
    if (self.view == nil || !channel)
    {
        return;
    }
    
    // Cancel any pending update
    [self.updateFromChannelOperation cancel];
    
    self.videoList = nil;
    
    self.updateFromChannelOperation = [self runOnUIThread:^
                                       {
                                           [self.playlistTray clearDynamicContent];
                                           [self updateChannelHighlightInTrayView];
                                           
                                           [self runOnBackgroundThread:^
                                            {
                                                NSError *error = nil;
                                                SearchResult *searchResult = [[VimondStore videoStore] videosForChannel:channel
                                                                                                              pageIndex:0
                                                                                                               pageSize:kMaxPlaylistLength sortBy:ProgramSortByPublishedDateDesc
                                                                                                                  error:&error];
                                                self.videoList = searchResult.items;
                                                
                                                if (error)
                                                {
                                                    return;
                                                }
                                                
                                                [self runOnUIThread:^
                                                 {
                                                     for (Video *video in self.videoList)
                                                     {
                                                         VideoCellView *videoCell = [[VideoCellView alloc] initWithCellSize:CellSizeSmall];
                                                         videoCell.video = video;
                                                         videoCell.animateSelection = YES;
                                                         [videoCell addTarget:self action:@selector(didTapVideoCell:) forControlEvents:UIControlEventTouchUpInside];
                                                         [self.playlistTray addViewToDynamicContent:videoCell];
                                                     }
                                                     
                                                     [self updateVideoHighlightInTrayView];
                                                 }];
                                            }];
                                       }];
}

- (int)indexOfVideo:(Video *)video
{
    int indexOfCurrentVideo = -1;
    
    for (int i = 0; i < self.videoList.count; ++i)
    {
        Video *videoFromList = [self.videoList objectAtIndex:i];
        if (videoFromList.identifier == video.identifier)
        {
            indexOfCurrentVideo = i;
            break;
        }
    }
    
    return indexOfCurrentVideo;
}

- (int)indexOfChannel:(Channel *)channel
{
    int indexOfChannel = -1;
    
    for (int i = 0; i < self.channelList.count; ++i)
    {
        Channel *channelFromList = [self.channelList objectAtIndex:i];
        if (channelFromList.identifier == channel.identifier)
        {
            indexOfChannel = i;
            break;
        }
    }
    
    return indexOfChannel;
}

- (void)updateVideoHighlightInTrayView
{
    [self.playlistTray selectDynamicContentAtIndex:[self indexOfVideo:self.currentVideo]];
}

- (void)updateChannelHighlightInTrayView
{
    [self.myChannelsTray selectDynamicContentAtIndex:[self indexOfChannel:self.currentChannel]];
}

- (void)updateFromVideo:(Video *)video
{
    
    //TODO: THis method is in serious need of re-factoring
    if (!self.isViewLoaded)
    {
        return;
    }
    
    if (video == nil)
    {
        //if video nil setting Viper (Prime Time) player asset to nil.
        [self.player changeAsset:nil];
        return;
    }
    
    [self.updateFromVideoOperation cancel];
    
    self.updateFromVideoOperation = [self runOnUIThread:^
                                     {
                                         self.title = video.title;
                                         [self updateVideoHighlightInTrayView];
                                         
                                         PlaybackStore *playbackStore = [VimondStore playbackStore];
                                         ProductAvailabilityService *productAvailabilityService = [ProductAvailabilityService sharedInstance];
                                         [self showBufferingIndicator];
                                         [self runOnBackgroundThread:^
                                          {
                                              NSError *error = nil;
                                              BOOL hasAccess = [productAvailabilityService hasAccessToVideo:video error:&error];
                                              if (error)
                                              {
                                                  [self runOnUIThread:^
                                                   {
                                                       [self.player changeAsset:nil];
                                                       [self showVideoFailedToLoad];
                                                       NSLog(@"Access to video Error %@", error);
                                                   }];
                                                  return;
                                              }
                                              
                                              Video *videoToPlay = hasAccess ? video : video.previewVideo;
                                              Playback *playback = [playbackStore playbackForVideo:videoToPlay error:&error];
                                              
                                              if (error)
                                              {
                                                  [self runOnUIThread:^
                                                   {
                                                       [self.player changeAsset:nil];
                                                       [self showVideoFailedToLoad];
                                                       NSLog(@"Playback store returned null %@", error);
                                                   }];
                                                  return;
                                              }
                                              
                                              PlayProgress *newProgress = [playbackStore playProgressForVideo:videoToPlay error:nil];
                                              self.progressChanged = ![newProgress isEqual:self.currentlyRestoredPlayProgress];
                                              self.currentlyRestoredPlayProgress = newProgress;
                                              
                                              [[GGUsageTracker sharedInstance] trackPlayVideo:videoToPlay preview:!hasAccess];
                                              
                                              [self runOnUIThread:^
                                               {
                                                   // Should help prevent the player from starting if the view is hidden.
                                                   BOOL viewControllerVisible = self.isViewLoaded && self.view.window;
                                                   if (!viewControllerVisible)
                                                   {
                                                       return;
                                                   }
                                                   
                                                   
#if TARGET_IPHONE_SIMULATOR
                                                   [self.loadingView showMessage:@"Video disabled in simulator"];
                                                   
#else // Don't let the video play in the simulator as it will cause a crash.
                                                   [self.interfaceVisibilityController startTrackingInactivity];
                                                   [self playerForVideoURL:[NSURL URLWithString:playback.streamURL]];
#endif
                                               }];
                                              
                                              [playbackStore logPlayback:playback error:&error];
                                              
                                              
                                              if (error)
                                              {
                                                  NSLog(@"Failed to log playback: %@", error);
                                              }
                                          }];
                                         
                                     }];
}


- (void)updateVideoBufferStatusGUI
{
    // buffered ranges are cleared off for slider. If condition added as this has to be done only if AVPlayer
    //in Viper (Prime Time) player is instantiated
    if(nil!=self.player.getAVPlayer)
    {
        [self.videoProgressSlider clearBufferedRanges];
    }
    
    //loadedTimeRanges of AVPlayer used by Viper(Prime Time) player
    NSArray *bufferedTimeRanges = self.player.getAVPlayer.currentItem.loadedTimeRanges;
    
    for (NSValue *bufferedTimeRangeWrapper in bufferedTimeRanges)
    {
        CMTimeRange bufferedTimeRange = bufferedTimeRangeWrapper.CMTimeRangeValue;
        NSRange bufferedRangeInSeconds;
        if (CMTIMERANGE_IS_VALID(bufferedTimeRange))
        {
            
            bufferedRangeInSeconds.location = (NSUInteger) CMTimeGetSeconds(bufferedTimeRange.start);
            bufferedRangeInSeconds.length = (NSUInteger) CMTimeGetSeconds(bufferedTimeRange.duration);
            [self.videoProgressSlider addBufferedRange:bufferedRangeInSeconds];
        }
    }
}

- (Float64)currentPlayerTimeInSeconds
{
    float res = CMTimeGetSeconds(self.player.getCurrentPosition);
    
    //isnan check added as Viper(Prime Time) player returns non number value at times
    if((isnan(res))||(res<0))
    {
        res = 0;
    }
    return res;
}


- (void)updateVideoDurationGUI
{

    CMTimeRange seekableTimeRange =  [self.player getSeekableTimeRange];
    
    if ((CMTIMERANGE_IS_VALID(seekableTimeRange))&&(!CMTIMERANGE_IS_EMPTY(seekableTimeRange)))
    {
        Float64 elapsedSeconds = [self currentPlayerTimeInSeconds];
        Float64 totalSeconds = CMTimeGetSeconds(seekableTimeRange.duration);
        if (totalSeconds<0) {
            totalSeconds = 0;
        }
        Float64 secondsLeft = totalSeconds - elapsedSeconds;
        if (secondsLeft<0) {
            secondsLeft = 0;
        }
        
        self.leftTimeLabel.text = [KITTimeUtils durationStringForDuration:elapsedSeconds];
        self.rightTimeLabel.text = [KITTimeUtils durationStringForDuration:secondsLeft];
        
        
        self.videoProgressSlider.enabled = YES;
        self.videoProgressSlider.minimumValue = 0;
        self.videoProgressSlider.maximumValue = (float) totalSeconds;
        
        // Don´t update the seeker head while the user is seeking.
        if (!self.isUserDraggingSeeker && !self.isPlayerSeeking)
        {
            self.videoProgressSlider.value = (float) elapsedSeconds;
        }
    }
    else
    {
        self.videoProgressSlider.enabled = NO;
        [self resetTimeLabels];
    }
    
}

- (void)updateVideoStatusGUI
{
    if (!self.isUserDraggingSeeker && !self.isPlayerSeeking)
    {
        [self updateVideoDurationGUI];
        [self updateVideoBufferStatusGUI];
    }
}

- (void)progressUpdateTimerTick
{
    if ([self isPlaying])
    {
        self.currentVideoWatchDuration += kVideoProgressUpdateInterval;
    }
    
    [self updateVideoStatusGUI];
}

- (void)showBufferingIndicator
{
    [self.loadingView startLoadingWithText:NSLocalizedString(@"BufferingLKey", @"")];
}

- (void)updateLoadingView
{
    // update loading status for Viper(Prime Time) player based on player status.
    NSString* strStatus = [self.player getPlayerStatus];
    if(([strStatus isEqualToString:VIPERPL_PLAYING])||([strStatus isEqualToString:VIPERPL_PAUSED])||([strStatus isEqualToString:VIPERPL_COMPLETED]))
    {
        [self.loadingView endLoading];
        
    }
    else if ([strStatus isEqualToString:VIPERPL_ERROR])
    {
        [self showVideoFailedToLoad];
    }
    else
    {
        [self showBufferingIndicator];
    }
}


- (CMTimeRange)currentlySeekableTimeRange
{
    return [self.player getSeekableTimeRange];
}


- (void)updatePlayPauseButton
{
    
    self.playPauseButton.enabled = CMTIMERANGE_IS_VALID([self currentlySeekableTimeRange]);
    
    BOOL paused = [[self.player getPlayerStatus]isEqualToString:VIPERPL_PAUSED];
    UIImage *image = paused ? [UIImage imageNamed:@"VideoPlayerPlayIcon"] : [UIImage imageNamed:@"PauseIcon.png"];
    [self.playPauseButton setImage:image forState:UIControlStateNormal];
}


#pragma mark - Properties

- (BOOL)isPlaying
{

    NSString* strStatus = [self.player getPlayerStatus];
    BOOL bRetPlayStatus = ([strStatus isEqualToString:VIPERPL_PLAYING])||([strStatus isEqualToString:VIPERPL_READY]);

    return bRetPlayStatus;
}

- (void)setCurrentVideo:(Video *)currentVideo
{
    BOOL changed = currentVideo != _currentVideo;
    if (changed)
    {
        [self trackWatchDurationForVideo:_currentVideo];
        [self storeProgressForCurrentVideo];
    }
    
    _currentVideo = currentVideo;
    [self updateFromVideo:currentVideo];
}

- (void)trackWatchDurationForVideo:(Video *)video
{
    if (!video) return;
    
    [[GGUsageTracker sharedInstance] trackPlayback:video duration:self.currentVideoWatchDuration];
    
    // Reset duration after it has been tracked.
    self.currentVideoWatchDuration = 0;
}

- (void)setCurrentChannel:(Channel *)currentChannel
{
    _currentChannel = currentChannel;
    [self updateFromChannel:currentChannel];
}

// Setter for Viper (Prime Time) player
- (void)setPlayer:(PlayerPlatformAPI *)player 
{
    //remove observers for player before destroying
    [self removeObserversForPlayer];
    [self.player stop];
    [self.player destroy];
    [self.playerLayerView setPtPlayer:player];
}

// Getter function for Viper (Prime Time) player
- (PlayerPlatformAPI *)player
{
    return self.playerLayerView.ptPlayer;
}

#pragma mark - Player methods

- (void)seekToTime:(NSTimeInterval)time
{
    CMTime timeToSeekTo = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    
    if (CMTIMERANGE_IS_VALID([self currentlySeekableTimeRange]))
    {
        //set the seeking player flag, so that slider is not updated
        self.isPlayerSeeking = YES;
        
        VideoPlaybackViewController* selfController = self;
        
        [self.player setPosition:timeToSeekTo completionHandler:^(BOOL finished)
         {
             if (finished) {
                 //reset the seeking player flag, so that slider can now be updated as operation is over
                 selfController.isPlayerSeeking = NO;
             }
             
         }];
    }
}


- (void)playPreviousVideo
{
    int indexOfPrevVideo = [self indexOfVideo:self.currentVideo] - 1;
    if (indexOfPrevVideo >= 0)
    {
        Video *prevVideo = [self.videoList objectAtIndex:indexOfPrevVideo];
        self.currentVideo = prevVideo;
    }
}

- (void)playNextVideo
{
    int indexOfNextVideo = [self indexOfVideo:self.currentVideo] + 1;
    if (indexOfNextVideo < self.videoList.count)
    {
        Video *nextVideo = [self.videoList objectAtIndex:indexOfNextVideo];
        self.currentVideo = nextVideo;
    }
}

- (void)handleEndOfPlaylist
{
    self.currentVideo = nil;
    
    // Expand the channel tray for the user to select a new channel to watch.
    [self.myChannelsTray expandTray];
    [self.playlistTray contractTray];
    [self setPlayBackControlsVisible:YES];
    [self.loadingView showMessage:NSLocalizedString(@"EndOfPlaylistLKey", @"")];
}


#pragma mark - Timer methods

- (void)stopAllTimers
{
    [self stopVideoLoadingTimeoutTimer];
    [self stopVideoProgressUpdateTimer];
    [self.interfaceVisibilityController stopTrackingInactivity];
}

- (void)startVideoLoadingTimeoutTimer
{
    [self.videoProgressUpdateTimer invalidate];
    self.videoProgressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kVideoTimeoutDuration target:self
                                                                   selector:@selector(videoLoadingTimedOut)
                                                                   userInfo:nil repeats:NO];
}

- (void)stopVideoLoadingTimeoutTimer
{
    [self.videoLoadingTimeoutTimer invalidate];
    self.videoLoadingTimeoutTimer = nil;
}

- (void)showVideoFailedToLoad
{
    [[GGUsageTracker sharedInstance]trackPlaybackFailed:self.currentVideo];
    [self.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingVideoLKey", @"")];
}

- (void)videoLoadingTimedOut
{
    [self showVideoFailedToLoad];
}

- (void)startVideoProgressUpdateTimer
{
    [self.videoProgressUpdateTimer invalidate];
    self.videoProgressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kVideoProgressUpdateInterval
                                                                     target:self
                                                                   selector:@selector(progressUpdateTimerTick)
                                                                   userInfo:nil
                                                                    repeats:YES];
    [self.videoProgressUpdateTimer fire];
}

- (void)stopVideoProgressUpdateTimer
{
    [self.videoProgressUpdateTimer invalidate];
    self.videoProgressUpdateTimer = nil;
}

- (void)animateSelectedItemFromTray:(VideoPlayerTrayView *)trayView
{
    int indexForCurrentItem = self.playlistTray == trayView ? [self indexOfVideo:self.currentVideo] : [self indexOfChannel:self.currentChannel];
    if (indexForCurrentItem != -1 && indexForCurrentItem < trayView.dynamicContentContainer.subviews.count)
    {
        CellView *view = [trayView.dynamicContentContainer.subviews objectAtIndex:indexForCurrentItem];
        view.selected = YES;
    }
}

- (void)toggleUIVisibility
{
    BOOL shouldShowUI = self.videoControlsContainer.hidden;
    [self setPlayBackControlsVisible:shouldShowUI];
}

- (void)setPlayBackControlsVisible:(BOOL)visible
{
    [[UIApplication sharedApplication] setStatusBarHidden:!visible withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:!visible animated:YES];
    
    self.volumeView.hidden = !visible;
    
    if (visible)
    {
        self.videoControlsContainer.hidden = NO;
    }
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^
     {
         CGFloat newAlpha = !visible ? 0 : 1;
         self.videoControlsContainer.alpha = newAlpha;
     }
                     completion:^(BOOL finished)
     {
         if (!visible)
         {
             self.videoControlsContainer.hidden = YES;
         }
     }];
}

- (void)timedUserInterfaceVisibilityController:(TimedUserInterfaceVisibilityController *)visibilityController didSetUIVisible:(BOOL)visible
{
    if ([self isPlaying])
    {
        [self setPlayBackControlsVisible:visible];
    }
}


#pragma mark - Notification handlers

- (void)didTapVideoPlayer:(UITapGestureRecognizer *)tapRecog
{
    [self toggleUIVisibility];
}

- (void)didSwipeVideoPlayer:(UISwipeGestureRecognizer *)swipeRecog
{
    if (swipeRecog.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self playPreviousVideo];
    }
    else
    {
        [self playNextVideo];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    
    Video *currentVideo = self.currentVideo;
    
    NSInteger indexOfCurrentVideo = [self indexOfVideo:currentVideo];
    NSInteger maxIndex = self.videoList.count - 1;
    if (indexOfCurrentVideo < maxIndex)
    {
        [self playNextVideo];
    }
    else
    {
        [self handleEndOfPlaylist];
    }
    
    [self resetProgressForVideo:currentVideo];
}

- (void)trayDidFinishContracting:(NSNotification *)notification
{
    UIView *trayToShow = notification.object == self.playlistTray ? self.myChannelsTray.trayTabView : self.playlistTray.trayTabView;
    trayToShow.hidden = NO;
    [UIView animateWithDuration:kTabFadeDuration animations:^
     {
         trayToShow.alpha = 1;
     }];
}

- (void)trayDidFinishExpanding:(NSNotification *)notification
{
    // Just animate the selected item when the tray is done expanding to give the user feedback on which video is currently playing.
    VideoPlayerTrayView *trayView = notification.object;
    [self animateSelectedItemFromTray:trayView];
}

- (void)trayDidStartExpanding:(NSNotification *)notification
{
    UIView *trayToHide = notification.object == self.playlistTray ? self.myChannelsTray.trayTabView : self.playlistTray.trayTabView;
    [UIView animateWithDuration:kTabFadeDuration animations:^
     {
         trayToHide.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         trayToHide.hidden = YES;
     }];
}

- (IBAction)didPressPlayPause:(id)sender
{
    if (self.isUserDraggingSeeker) // Safety measure in case it´s possible to press the play/pause button while seeking
    {
        return;
    }
    //set play/pause button according to Viper(Prime Time) player status 
    NSString* strStatus = [self.player getPlayerStatus];
    if ([strStatus isEqualToString:VIPERPL_PLAYING]) {
        [self.player pause];
    }else{
        [self.player play];
    }
    
    [self updatePlayPauseButton];
}

- (IBAction)progressSliderValueChanged
{
    [self seekToTime:self.videoProgressSlider.value];
    [self updateVideoDurationGUI];
}

- (IBAction)progressSliderTouchDown:(id)sender
{
    self.restoreToPlaybackRate = self.player.getAVPlayer.rate;
    //added the following as a check if return value is not a number
    if (isnan(self.restoreToPlaybackRate)) {
        self.restoreToPlaybackRate = 1.0f;
    }
    self.player.getAVPlayer.rate = 0.0f;
    self.isUserDraggingSeeker = YES;
}

- (IBAction)progressSliderTouchUpInside:(id)sender
{
    self.player.getAVPlayer.rate = self.restoreToPlaybackRate;
    self.isUserDraggingSeeker = NO;
}

- (void)didTapVideoCell:(VideoCellView *)sender
{
    if (sender.video)
    {
        self.currentVideo = sender.video;
    }
}

- (void)didTapChannelCell:(ChannelCellView *)sender
{
    if (sender.channel)
    {
        self.currentChannel = sender.channel;
        
        [self.myChannelsTray contractTray];
        [self.playlistTray expandTray];
    }
}


- (void)didPressFavoriteButton:(FavoriteBarButtonItem *)favoriteButton
{
    favoriteButton.favorited = !favoriteButton.favorited;
    [self runOnBackgroundThread:^
     {
         FavoriteStore *store = [VimondStore favoriteStore];
         NSError *error = nil;
         BOOL isFavorite = [store isFavorite:self.currentVideo error:&error];
         if (error != nil)
         {
             [self showError:error];
             return;
         }
         
         if (!isFavorite)
         {
             [store addToFavorites:self.currentVideo error:&error];
             [[GGUsageTracker sharedInstance] trackFavoriteVideo:self.currentVideo];
         }
         else
         {
             [store removeFromFavorites:self.currentVideo error:&error];
         }
         
         [self runOnUIThread:^
          {
              favoriteButton.favorited = !isFavorite;
          }];
     }];
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self updateFromVideo:self.currentVideo];
    [self updateLoadingView];
}

#pragma mark - Progress handling

- (void)showResumeProgressPrompt
{
    [self.player pause];
    
    self.resumeProgressView.hidden = NO;
    self.resumeProgressView.alpha = 0;
    self.resumeProgressView.layer.cornerRadius = 5;
    self.resumeProgressView.layer.borderColor = [[UIColor colorWithWhite:0.33 alpha:1]CGColor];
    self.resumeProgressView.layer.borderWidth = 1;
    [UIView animateWithDuration:kResumePromptFadeDuration animations:^
     {
         self.resumeProgressView.alpha = 1;
     }];
}

- (void)hideResumeProgressPrompt
{
    [UIView animateWithDuration:kResumePromptFadeDuration animations:^
     {
         self.resumeProgressView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         self.resumeProgressView.hidden = NO;
     }];
}

- (IBAction)startFromBeginning
{
    [self resetProgressForVideo:self.currentVideo];
    [self.player play];
    self.currentlyRestoredPlayProgress = nil;
    [self hideResumeProgressPrompt];
}

- (IBAction)resumeWithCurrentProgress
{
    [self handleResumeWithProgress:self.currentlyRestoredPlayProgress];
    //    self.currentlyRestoredPlayProgress = nil;
    [self hideResumeProgressPrompt];
}

- (void)handleResumeWithProgress:(PlayProgress *)progress
{
    if (progress)
    {
        [self seekToTime:progress.offsetSeconds];
        [self.player play];
    }
}

- (void)storeProgressForCurrentVideo
{
    [self storeProgress:[self currentPlayerTimeInSeconds] forVideo:self.currentVideo];
}

- (void)storeProgress:(NSTimeInterval)progressInSeconds forVideo:(Video *)video
{
    if (!video) {
        return;
    }
    
    NSTimeInterval truncatedProgress = floor(progressInSeconds);
    self.currentlyRestoredPlayProgress.offsetSeconds = truncatedProgress;
    
    [self.storeProgressOperation cancel];
    self.storeProgressOperation = [NSBlockOperation blockOperationWithBlock:^
                                   {
                                       NSError *error = nil;
                                       [[VimondStore playbackStore] storeProgressForVideo:video
                                                                            offsetSeconds:truncatedProgress
                                                                                    error:&error];
                                       
                                       // Ignore, but log errors in storing video progress.
                                       if (error)
                                       {
                                           DLog(@"%@",error);
                                       }
                                   }];
    
    [self.nonInterruptedBgQueue addOperation:self.storeProgressOperation];
}

- (void)resetProgressForVideo:(Video*)video
{
    [self storeProgress:0 forVideo:video];
}

- (NSString *)generateTrackingPath
{
    return @"/Video_Player";
}


#pragma mark - Viper (Prime Time) player notifications

// Error thrown from Viper(Prime Time) player is logged here.
- (void)onMediaPlayerError:(NSNotification *)notification
{
    // the error is also available as [self.player.error]
    PlayerPlatformMediaFailedEventData *error = [[PlayerPlatformMediaFailedEventData alloc] init];
    [error fromDictionary:notification.userInfo];
    
    NSString *errorMessage = [NSString stringWithFormat:@"Major: %@ Descrption:%@",error.code, error.description];

    NSLog(@"Playback Error %@", errorMessage);
    
    
}


// Viper(Prime Time) player status time change call back function
- (void) onMediaPlayerTimeChange:(NSNotification *)notification
{
    
}


// Viper(Prime Time) player call back on status change
- (void) onMediaPlayerStateChaged:(NSNotification *)notification
{
    PlayerPlatformMediaPlayStateChangedEventData *eventData = [[PlayerPlatformMediaPlayStateChangedEventData alloc] init];
    [eventData fromDictionary:notification.userInfo];
    
    
    NSLog(@"Viper status change notification. %d. %@. %@", self.player.getAVPlayer.status, eventData.playState, eventData.description);
    
    // update status of timeout timer, based on player status
    [self updateTimeoutTimer];
    
    if (([eventData.playState isEqualToString:VIPERPL_PLAYING])||([eventData.playState isEqualToString:VIPERPL_READY])) {
        
        // update loading view based on player status
        [self updateLoadingView];
        
        // start updating video progress
        [self startVideoProgressUpdateTimer];
        
    }else if([eventData.playState isEqualToString:VIPERPL_ERROR])
    {
        // update loading view in case of error
        [self updateLoadingView];
        
    }
    [self updateVideoStatusGUI];
    [self updatePlayPauseButton];
    
    
}

// Viper(Prime Time) player callback on media play complete
-(void)onMediaComplete:(NSNotification*)notification
{
    Video *currentVideo = self.currentVideo;
    
    NSInteger indexOfCurrentVideo = [self indexOfVideo:currentVideo];
    NSInteger maxIndex = self.videoList.count - 1;
    if (indexOfCurrentVideo < maxIndex)
    {
        [self playNextVideo];
    }
    else
    {
        [self handleEndOfPlaylist];
    }
    
    [self resetProgressForVideo:currentVideo];
    
}

// Viper(Prime Time) player callback on Drm complete
// Now this is not handled
-(void)onDrmCompleteForPlayer:(NSNotification*)notification
{

}

// Viper(Prime Time) player callback on Drm failure
// Now only logging is done
-(void)onDrmFailureForPlayer:(NSNotification*)notification
{
    PlayerPlatformDrmFailureEventData *event = [[PlayerPlatformDrmFailureEventData alloc] init];
    [event fromDictionary:notification.userInfo];
    NSString *errorMessage;
    errorMessage = [NSString stringWithFormat:@"Drm Error Major:%@ Minor:%@",event.major,event.minor];
    NSLog(@"%@", errorMessage);
}


@end
