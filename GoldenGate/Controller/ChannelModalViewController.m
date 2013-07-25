//
//  ChannelModalViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ChannelModalViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Channel.h"
#import "PGRatingView.h"
#import "Video.h"
#import "VideoTableCell.h"
#import "VideoPlaybackViewController.h"
#import "ModalRelatedContentViewController.h"
#import "VimondStore.h"
#import "LikeBarButton.h"
#import "TVImageView.h"
#import "LikeLabel.h"
#import "ChannelCellView.h"
#import "VideosForChannelDataFetcher.h"
#import "ProgramSortUIName.h"
#import "NavActionExecutor.h"
#import "GGUsageTracker.h"

#define kCellIdentifier @"VideoTableCell"
#define kFlipAnimationDuration 0.5
#define kPresentationAnimationDuration 0.2
#define kFadeInAnimationDuration 0.2
#define kElementPadding 3
#define kLastUsedSortModeKeyName @"channelViewLastUsedSortMode"

static ChannelModalViewController *gInstance;

@interface ChannelModalViewController ()

@property (weak, nonatomic) IBOutlet UILabel         *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel         *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel         *channelDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel         *publisherLabel;
@property (weak, nonatomic) IBOutlet TVImageView     *channelLogoView;
@property (weak, nonatomic) IBOutlet UITableView     *videoTableView;
@property (weak, nonatomic) IBOutlet PGRatingView    *pgRatingView;
@property (weak, nonatomic) IBOutlet LoadingView     *loadingView;
@property (weak, nonatomic) IBOutlet UIView          *relatedContentView;
@property (weak, nonatomic) IBOutlet UIView          *contentView;
@property (weak, nonatomic) IBOutlet UIView          *contentMainFrame;
@property (weak, nonatomic) IBOutlet UIView          *tapToDismissView;
@property (weak, nonatomic) IBOutlet UIView          *channelInfoContainer;
@property (weak, nonatomic) IBOutlet LikeLabel       *likeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

@property (weak, nonatomic) UIView *sourceChannelView; // The view that was tapped to present the channelview controller.

@property (strong, nonatomic) ModalRelatedContentViewController * relatedContentViewController;
@property (strong, nonatomic) VideoPlaybackViewController *videoPlaybackViewController;

@property (strong, nonatomic) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) VideosForChannelDataFetcher *dataFetcher;

// Store initial rect of the channel description label so it can be used as a max value for this height.
@property (assign, nonatomic) CGRect maxChannelDescriptionLabelFrame;

@property (assign, nonatomic) CGFloat maxChannelInfoContainerHeight;

@end

@implementation ChannelModalViewController
@synthesize likeButton = _likeButton;

+ (BOOL)shouldAnimateWhenPresentingFromView:(UIView*)view
{
    BOOL shouldAnimate = view != nil && view.frame.size.height / view.frame.size.width;
    
    // Only animate relatively a certain group of cells
    if ([view isKindOfClass:[CellView class]])
    {
        CellView *cell = (CellView*)view;
        shouldAnimate = cell.cellSize <= CellSizeLarge;
    }
    
    return shouldAnimate;
}

+ (void)showFromView:(UIView *)view withChannel:(Channel *)channel navController:(UINavigationController *)navController
{
    if (gInstance == nil || gInstance.view.superview == nil)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDismissSearchPopover object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNavigationPopoverDismiss object:nil];
        
        ChannelModalViewController *channelViewController = [ChannelModalViewController new];
        channelViewController.channel = channel;
        channelViewController.navController = navController;
        channelViewController.sourceChannelView = view;
        
        gInstance = channelViewController;
        
        [[self overlayView]addSubview:channelViewController.view];
        
        if ([self shouldAnimateWhenPresentingFromView:view])
        {
            channelViewController.sourceChannelView.hidden = YES;
            [channelViewController animateView:channelViewController.contentMainFrame
                                      fromView:view
                                        toView:channelViewController.contentMainFrame
                                   reverseAnim:NO];
        }
        else
        {
            channelViewController.view.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^
            {
                channelViewController.view.alpha = 1;
            }];
        }
        
        
        channelViewController.tapToDismissView.alpha = 0;
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^
        {
            channelViewController.tapToDismissView.alpha = kDimmingViewAlpha;
        }];
        
        // Hack: Have to do this since this view never lives on the navigation stack
        [channelViewController viewDidAppear:YES];
    }
}


- (id)init
{
    NSString *nibName = NSStringFromClass([self class]);
    if ((self = [self initWithNibName:nibName bundle:nil]))
    {
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)dealloc
{
    gInstance = nil;
}

/*!
 Views do not recognize taps, so here we add gesture recognizers to
 figure out if user tapped Related content in upper right corner or outside
 dialog to dismiss it.
*/
- (void)setupTapRecognizers
{
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentRelatedContent)];
    [self.relatedContentView addGestureRecognizer:tapRecog];
    
    UITapGestureRecognizer *dismissTapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    [self.tapToDismissView addGestureRecognizer:dismissTapRecog];
    self.tapToDismissView.layer.zPosition = -1;
}

- (NSInteger)lastUsedSortModeIndex
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:kLastUsedSortModeKeyName];
    return [num intValue];
}

- (void)storeLastUsedSortModeIndex:(NSInteger)lastUsedSortModeIndex
{
    [[NSUserDefaults standardUserDefaults]setObject:@(lastUsedSortModeIndex) forKey:kLastUsedSortModeKeyName];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setupSortingSegmentedController
{
    NSArray *sortModes = [self sortModes];
    [self.sortSegmentedControl removeAllSegments];
    [self.sortSegmentedControl addTarget:self action:@selector(sortModeChanged) forControlEvents:UIControlEventValueChanged];

    
    [sortModes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSString *uiName = [ProgramSortUIName uiNameForProgramSortBy:(ProgramSortBy) [obj intValue]];
        [self.sortSegmentedControl insertSegmentWithTitle:uiName atIndex:idx animated:NO];
    }];
    
    self.sortSegmentedControl.selectedSegmentIndex = [self lastUsedSortModeIndex];
    [self updateSortModeFromSelectedIndex];
}

- (void)viewDidLoad
{
    // Change style before super viewDidLoad so that the labels get proper localization.
    self.loadingView.style = LoadingViewStyleForLightBackground;
    
    [super viewDidLoad];
    
    self.maxChannelDescriptionLabelFrame   = self.channelDescriptionLabel.frame;
    self.maxChannelInfoContainerHeight      = self.channelInfoContainer.frame.size.height;
    
    self.contentMainFrame.layer.cornerRadius = 5;

    [self setupTapRecognizers];
    [self setupSortingSegmentedController];
    
    [self updateFromChannel:self.channel];
}

- (void)presentRelatedContent
{
    [self presentRelatedContentForChannel:self.channel];
}

- (void)presentRelatedContentForChannel:(Channel*)channel
{
    if (self.relatedContentViewController == nil)
    {
        self.relatedContentViewController = [ModalRelatedContentViewController new];
        self.relatedContentViewController.dismissSelector = @selector(dismissRelatedContentView);
        self.relatedContentViewController.channelModalViewController = self;
        self.relatedContentViewController.dismissTarget = self;
        self.relatedContentViewController.navController = self.navController;
    }
    
    self.relatedContentViewController.channel = channel;

    [UIView transitionWithView:self.contentMainFrame duration:kFlipAnimationDuration
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^
     {
         self.contentView.hidden = YES;
         [self.contentMainFrame addSubview:self.relatedContentViewController.view];
     }
                    completion:^(BOOL finished)
     {
         [self.relatedContentViewController fadeInNavBar];
     }];
}

- (void)dismissRelatedContentView
{
    [UIView transitionWithView:self.contentMainFrame duration:kFlipAnimationDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^
     {
         [self.relatedContentViewController.view removeFromSuperview];
         self.contentView.hidden = NO;
         [self.contentMainFrame addSubview:self.contentView];
     }
                    completion:^(BOOL finished)
     {
         // Hack: Have to do this since this view never lives on the navigation stack
         [self viewDidAppear:YES];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.videoTableView deselectRowAtIndexPath:self.videoTableView.indexPathForSelectedRow animated:YES];
}

- (void)updateLikeCountFromChannel:(Channel*)channel
{
    self.likeLabel.likeCount = channel.likeCount;
}

- (void)reloadTable
{
    [self.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    [self.dataSource fetchDataObjectAtIndex:0
                             successHandler:^(NSObject *dataObject)
     {
         [self.videoTableView reloadData];
         self.videoTableView.hidden = NO;
         self.videoCountLabel.hidden = NO;
         [self.loadingView endLoading];
         
         
         [self updateVideoCountLabelWithCount:self.dataSource.cachedTotalItemCount];
         
         if (self.dataSource.cachedTotalItemCount == 0)
         {
             [self.loadingView showMessage:NSLocalizedString(@"ChannelHasNoVideosLKey", @"")];
         }
     }
                               errorHandler:^(NSError *error)
     {
         [self.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
         self.videoTableView.hidden = YES;
     }];
}

- (void)updateFromChannel:(Channel *)channel
{
    if (channel == nil || !self.isViewLoaded)
    {
        return;
    }

    self.dataFetcher.sourceObject = channel;
    
    [self updateLikeCountFromChannel:channel];
    
    CGFloat pixelScale = [UIScreen mainScreen].scale; 
    self.channelLogoView.imageURL       = [channel logoURLStringForSize:CGSizeMake(self.channelLogoView.bounds.size.width  * pixelScale,
                                                                                   self.channelLogoView.bounds.size.height * pixelScale)];
    self.channelNameLabel.text          = channel.title;
    self.pgRatingView.rating            = channel.pgRating;
    self.publisherLabel.text            = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), channel.publisher];
    self.channelDescriptionLabel.frame  = [self calculateDescriptionLabelFrame];
    self.channelDescriptionLabel.text   = channel.summary;
    [self.channelInfoContainer setNeedsLayout];
    
    self.videoTableView.hidden = YES;
    self.videoCountLabel.hidden = YES;
    
    [self reloadTable];

    self.likeButton.customView.hidden = YES;
    [[VimondStore ratingStore]isChannelLiked:channel onSuccess:^(BOOL isLiked)
    {
        self.likeButton.liked = isLiked;
        self.likeButton.customView.hidden = NO;
    }];
}

- (void)updateVideoCountLabelWithCount:(NSUInteger)videoCount
{
    self.videoCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"NumberOfVideosLKey",@""), videoCount];
}

- (void)setChannel:(Channel *)channel
{
    _channel = channel;
    
    [self updateFromChannel:channel];
}

- (IBAction)dismiss:(id)sender
{
    BOOL shouldAnimate = [ChannelModalViewController shouldAnimateWhenPresentingFromView:self.sourceChannelView];
    
    if (shouldAnimate)
    {
        if ([self.sourceChannelView isKindOfClass:[ChannelCellView class]])
        {
            // Force an update of the channelview cell in case the user has liked the channel.
            ChannelCellView *channelCellView = (ChannelCellView *)self.sourceChannelView;
            channelCellView.channel = channelCellView.channel;
        }
        
        [self animateView:self.contentMainFrame fromView:self.sourceChannelView toView:self.contentMainFrame reverseAnim:YES];
    }
    
    [UIView animateWithDuration:kFadeInAnimationDuration animations:^
     {
         self.tapToDismissView.alpha = 0;
         
         if (!shouldAnimate)
         {
             self.contentMainFrame.alpha = 0;
         }
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         self.sourceChannelView.hidden = NO;
         gInstance = nil;
     }];
}

/*!
 This method is used for animating the view from the cell a user presses to the final size of the view.
 @param view The view to whichthe animation actually will be applied.
 @param fromView defines the starting position of the animation
 @param fromView defines the ending position of the animation
 @param reverse if YES the animation will be reversed.
*/
- (void)animateView:(UIView*)view fromView:(UIView*)fromView toView:(UIView*)toView reverseAnim:(BOOL)reverse
{
    CGRect startRect = [self.view convertRect:fromView.frame fromView:fromView.superview];

    CGFloat halfWidth   = self.view.frame.size.width  / 2;
    CGFloat halfHeight  = self.view.frame.size.height / 2;

    // Wrap transform in value so that it can be in the keyframe array.
    NSValue *initialTransformValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    // move to location of channel tile in MainCategory
    CATransform3D translation = CATransform3DMakeTranslation(startRect.origin.x + (startRect.size.width / 2)  - halfWidth,
                                                             startRect.origin.y + (startRect.size.height / 2) - halfHeight,
                                                             0.0);
    
    CGFloat xScaleFactor = fromView.bounds.size.width  / toView.bounds.size.width;
    CGFloat yScaleFactor = fromView.bounds.size.height / toView.bounds.size.height;
    
    CATransform3D scalingAndTranslation = CATransform3DScale(translation, xScaleFactor, yScaleFactor, 1.0);
    CATransform3D finalTransform = CATransform3DRotate(scalingAndTranslation, 0 , 0.0, 1.0, 0.0);
    
    NSArray *keyFrameValues = reverse ?
        [NSArray arrayWithObjects:initialTransformValue, [NSValue valueWithCATransform3D:finalTransform], nil] :
        [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:finalTransform], initialTransformValue, nil];
    
    CAKeyframeAnimation *myAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    myAnimation.values = keyFrameValues;
    myAnimation.duration = kPresentationAnimationDuration;
    myAnimation.removedOnCompletion = NO;
    myAnimation.fillMode = kCAFillModeForwards;

    
    [self.contentMainFrame.layer addAnimation:myAnimation forKey:@"myAnimationKey"];
}

+ (UIView*)overlayView
{
    return [[[[UIApplication sharedApplication]keyWindow]subviews]objectAtIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.cachedTotalItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableCell *videoTableCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (videoTableCell == nil)
    {
        videoTableCell = [[VideoTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    [self.dataSource fetchDataObjectAtIndex:(NSUInteger) indexPath.row
                             successHandler:^(NSObject *dataObject)
    {
        videoTableCell.video = (Video *)dataObject;
    } errorHandler:nil];
    
    tableView.accessibilityLabel=@"VideoTable";
    //
   // if(indexPath.row==1)
    //    [videoTableCell setAccessibilityLabel:@"ChannelModal"];
    //Home
    if(indexPath.row==3)
        [videoTableCell setAccessibilityLabel:@"HomeChannelModal"];

    return videoTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource fetchDataObjectAtIndex:(NSUInteger) indexPath.row
                             successHandler:^(NSObject *dataObject)
    {
        [VideoPlaybackViewController presentVideo:(Video *) dataObject
                                      fromChannel:self.channel
                         withNavigationController:self.navController];
    } errorHandler:nil];
}

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self updateFromChannel:self.channel];
}

- (CGRect)calculateDescriptionLabelFrame
{
    CGSize constraint = self.maxChannelDescriptionLabelFrame.size;
    CGSize descriptionSize = [self.channel.summary sizeWithFont:self.channelDescriptionLabel.font
                                          constrainedToSize:constraint
                                              lineBreakMode:NSLineBreakByWordWrapping];
    CGRect descLabelFrame = self.channelDescriptionLabel.frame;
    descLabelFrame.size = descriptionSize;
    
    return descLabelFrame;
}


- (IBAction)didPressLikeButton:(id)sender
{
    if (self.likeButton.liked) {
        return;
    }
    
    // Do this to make toggle instantaneous.
    self.likeButton.liked = YES;
    
    // Fake an update in the likecount just to give the user feedback.
    NSInteger newLikeCount = self.likeButton.liked ? self.channel.likeCount + 1 : self.channel.likeCount - 1;
    self.channel.likeCount = MAX(0, newLikeCount);
    [self updateLikeCountFromChannel:self.channel];
    [NavActionExecutor clearViewControllerCache];
    [[VimondStore ratingStore] likeChannel:self.channel onSuccess:^(BOOL success)
    {
        [[GGUsageTracker sharedInstance] trackLikeChannel:self.channel];
        // A synch with the ACTUAL like state once the API call returns just in case.
        self.likeButton.liked = success;
    }];
}

- (void)updateSortModeFromSelectedIndex
{
    ProgramSortBy sortMode = (ProgramSortBy) [[[self sortModes]objectAtIndex:self.sortSegmentedControl.selectedSegmentIndex]intValue];
    self.dataSource.sortBy = sortMode;
    [self storeLastUsedSortModeIndex:self.sortSegmentedControl.selectedSegmentIndex];
}
- (void)sortModeChanged
{
    [self updateSortModeFromSelectedIndex];
    [self reloadTable];
}


#pragma mark - Properties

- (PrefetchingDataSource*)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [PrefetchingDataSource createWithDataFetcher:self.dataFetcher];
    }
    
    return _dataSource;
}

- (VideosForChannelDataFetcher *)dataFetcher
{
    if (_dataFetcher == nil)
    {
        _dataFetcher = [VideosForChannelDataFetcher new];
    }

    return _dataFetcher;
}

- (NSArray*)sortModes
{
    return @[@(ProgramSortByPublishedDateDesc), @(ProgramSortByViewDesc)];//Satish: deleted , @(ProgramSortByRatingCount) to remove sort by likes 
}

- (NSString*)generateTrackingPath
{
    id<TrackingPathGenerating> parentViewController = (id<TrackingPathGenerating>)self.navController.topViewController;
    NSAssert([parentViewController conformsToProtocol:@protocol(TrackingPathGenerating) ], @"View controller must implement TrackingPathGenerating");
    
    return [NSString stringWithFormat:@"%@/Channel_View", [parentViewController generateTrackingPath]];
}

@end
