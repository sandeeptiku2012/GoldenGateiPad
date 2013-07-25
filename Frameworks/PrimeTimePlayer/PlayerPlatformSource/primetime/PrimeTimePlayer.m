//
//  PrimeTimeXvid.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "PrimeTimePlayer.h"
#import "PTMetadata.h"
#import "PTMediaPlayer.h"
#import "PTMediaPlayerItem.h"
#import "PTMediaError.h"
#import "PTMediaPlayerNotifications.h"
#import "PTMediaPlayerView.h"
#import "PTAdBreak.h"
#import "PlayerPlatformVideoEvent.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerPlatformMediaFailedEventData.h"
#import "PlayerPlatformMediaOpenedEventData.h"
#import "PlayerPlatformMediaFailedEventData.h"
#import "PlayerPlatformMediaProgressEventData.h"
#import "PlayerPlatformDrmFailureEventData.h"
#import "PlayerPlatformMediaPlayStateChangedEventData.h"
#import "IPlayerPlatform.h"
#import "PlayerPlatformMediaChangedEventData.h"
#import "DRMProvider.h"
#import "AssetBuilder.h"
#import "PlayerPlatformBitrateChangedEventData.h"
#import "PTAuditudeMetadata.h"
#import "PTMediaSelectionOption.h"
#import "PTABRControlParameters.h"
#import <PlayerPlatformUtil/ConfigurationManager.h>
#import "VideoAd.h"
#import "VideoAdBreak.h"
#import "PlayerPlatformAdBreakCompleteEventData.h"
#import "PlayerPlatformAdBreakStartedEventData.h"
#import "PlayerPlatformAdPlayCompleteEventData.h"
#import "PlayerPlatformAdPlayProgressEventData.h"
#import "PlayerPlatformAdPlayStartedEventData.h"

@interface PrimeTimePlayer ()
{
    
    PTMediaPlayer *_player;
    Asset *_currentAsset;
    
    bool _autoPlay;
    bool _isStopped;
    int _updateInterval;
    bool _captionsEnabled;
    
    DRMManager *_drmManger;
    DRMMetadata *_drmMetadata;
    DRMSession *_drmSession;
    DRMPolicy *_drmPolicy;
    
    bool _drmComplete;
    
    NSTimer *_heartbeatTimer;
    double _heartbeatInterval;
    bool _heartbeatEnabled;
    double _latestBitrate;
    
    XuaPlayerParams *_xuaPlayerParams;
    
    NSString *_adZoneId;
    NSString *_adDomain;
    
    int _initialBitrate;
    int _maxBitrate;
    int _minBitrate;
    BOOL _bitrateConfigured;
}
@end

@implementation PrimeTimePlayer

@synthesize autoPlay = _autoPlay;
@synthesize updateInterval = _updateInterval;
@synthesize captionsEnabled = _captionsEnabled;
@synthesize player = _player;


-(id)init
{
    self = [super init];
    //[PTMediaPlayer enableDebugLog:true];
    _player = [[PTMediaPlayer alloc]init];
    _drmComplete = false;
    _isStopped = false;
        
    _autoPlay = true;
    _updateInterval = 1000;
    _captionsEnabled = true;
    _bitrateConfigured = false;
    _player.autoPlay = false;
    _player.currentTimeUpdateInterval = self.updateInterval;

    _player.videoGravity = PTMediaPlayerVideoGravityResizeAspect;
    _player.allowsAirPlayVideo = YES;
    _latestBitrate = 0;
    _initialBitrate = [[[ConfigurationManager sharedInstance] getConfigValue:INITIAL_BITRATE] integerValue];
    _minBitrate = [[[ConfigurationManager sharedInstance] getConfigValue:MINIMUM_BITRATE] integerValue];
    _maxBitrate = [[[ConfigurationManager sharedInstance] getConfigValue:MAXIMUM_BITRATE] integerValue];
    
    //NSLog(@"Player initialized. autoplay: %d, updateInterval: %d, captionsEnabled: %d,",_autoPlay,_updateInterval,_captionsEnabled);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerTimeChange:) name:PTMediaPlayerTimeChangeNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerStatusChange:) name:PTMediaPlayerStatusNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemChanged:) name:PTMediaPlayerItemChangedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemPlayStarted:) name:PTMediaPlayerPlayStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemPlayCompleted:) name:PTMediaPlayerPlayCompletedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerNotificationItemEntry:) name:PTMediaPlayerNewNotificationEntryAddedNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdBreakStarted:) name:PTMediaPlayerAdBreakStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdBreakCompleted:) name:PTMediaPlayerAdBreakCompletedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdStarted:) name:PTMediaPlayerAdStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdProgress:) name:PTMediaPlayerAdProgressNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdCompleted:) name:PTMediaPlayerAdCompletedNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmComplete:) name:@"InternalDrmComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmFailure:) name:@"InternalDrmFailure" object:nil];
    
    
    [_player addObserver:self
              forKeyPath:@"currentItem"
                 options:NSKeyValueObservingOptionNew
                 context:@selector(observeValueForKeyPath)];


    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                         ofObject:(id)object
                           change:(NSDictionary *)change
                          context:(void *)context {
    
    if ([keyPath isEqual:@"currentItem"]) {
        [_player prepareToPlay];
    }
}

-(void)destroy
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerTimeChangeNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerStatusNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerItemChangedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerPlayStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerPlayCompletedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerNewNotificationEntryAddedNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerAdBreakStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerAdBreakCompletedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerAdStartedNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerAdProgressNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTMediaPlayerAdCompletedNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_COMPLETE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OFFLINE_DRM_COMPLETE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OFFLINE_DRM_FAILURE object:nil];

    //Satish: These lines added to remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InternalDrmComplete" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InternalDrmFailure" object:nil];
    [_player removeObserver:self forKeyPath:@"currentItem"];
    
    
    [self releaseHeartbeatTimer];
    
    _player = nil;
    _drmSession = nil;
    _drmMetadata = nil;
    _drmPolicy = nil;
    _currentAsset = nil;
    _drmManger = nil;
    _drmComplete = nil;
    _autoPlay = nil;
    _captionsEnabled = nil;
}

-(void)initQos
{
    [self initHeartbeatTimer];
}

-(void)changeAsset:(Asset *)asset
{
    _currentAsset = asset;
    
    if ([_currentAsset.manifestUrl rangeOfString:@"?"].location == NSNotFound) {
        asset.manifestUrl = [asset.manifestUrl stringByAppendingString:@"?faxs=1"];
    }
    else
    {
        asset.manifestUrl = [asset.manifestUrl stringByAppendingString:@"&faxs=1"];
    }
    
    [self sendOpeningMessage];
        
    PTMediaPlayerItem *item = [[PTMediaPlayerItem alloc] initWithUrl:[NSURL URLWithString:asset.manifestUrl]
                                                             mediaId:[asset.contentOptions valueForKey:ASSET_ID]
                                                            metadata:[self generateAssetMetadata]];
    item.secure = NO;
    
    [_player replaceCurrentItemWithPlayerItem:item];
    
    item = nil;
    
}

-(void)play;
{
    if(_drmComplete)
    {
        _isStopped = true;
        [self initHeartbeatTimer];
        [_player play];
    }
}

-(void)pause;
{
    [_player pause];
}

-(void)stop;
{
    [_player stop];
    _drmComplete = false;
    _isStopped = true;
    [self releaseHeartbeatTimer];
}

-(void)reset
{
    [_player reset];
}

-(void)setContentURL:(NSString *)url withContentOptions:(NSMutableDictionary *)contentOptions
{
    
    if ([NSURL URLWithString:url] == nil) {
        return;
    }
    
    [self initQos];
    
    Asset* asset = [[Asset alloc] init];
    asset.contentOptions = contentOptions;
    asset.manifestUrl = url;    
    _isStopped = false;
    
    [self changeAsset:asset];
}
-(void)seekToLive
{
    [NSException raise:@"NotImplementedException" format:@"This function is not available in this version of the player"];
}

-(CMTimeRange)getSeekableTimeRange
{
    return [_player seekableRange];
}

-(void)setPosition:(CMTime)seconds
{
    [_player seekToTime:seconds];
}

-(void)setPosition:(CMTime)time completionHandler:(void (^)(BOOL))completionHandler
{
    [_player seekToTime:time completionHandler:completionHandler];
}

-(void)setPositionRelative:(CMTime)seconds
{
    [_player seekToTime:CMTimeAdd([_player currentTime], seconds)];
}
-(NSArray*)getSupportedPlaybackSpeeds;
{
    NSArray* speeds = [[NSArray alloc] init];
    return speeds;
}
-(CMTime)getEndPosition
{
    return [_player currentItem].duration;
}
-(CMTime)getStartPosition
{
    return CMTimeMakeWithSeconds(0, 0);
}
-(CMTime)getCurrentPosition
{
    return _player.currentTime;
}
-(CMTime)getDuration
{
    return [_player currentItem].duration;
}

-(BOOL)isDrmProtected
{
    return [[_player currentItem] isDrmProtected];
}

-(PTMediaPlayerView*)getView
{
    return _player.view;
}
-(void)setSpeed:(CGFloat)speed withOvershootCorrection:(CGFloat)overshootCorrection
{
    [NSException raise:@"NotImplementedException" format:@"This function is not available in this version of the player"];
}
-(void)setVolume:(NSInteger*)volume
{
    [NSException raise:@"NotImplementedException" format:@"This function is not available in this version of the player"];
}
-(CGFloat)getCurrentPlaybackSpeed
{
    return _player.rate;
}
-(NSString*)getPlayerStatus
{
    return [self primeTimeStatusToString:_player.status];
}
-(BOOL)getClosedCaptionStatus
{
    return [_player isClosedCaptionDisplayEnabled];
}
-(NSArray*)getBitrateRange
{
    NSArray *range = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_minBitrate],[NSNumber numberWithInt:_maxBitrate], nil];
    return range;
}

-(int)getInitialBitrate;
{
    return _initialBitrate;
}

-(double)getBitrate
{
    NSArray *events = [[[[self getAVPlayer] currentItem] accessLog] events];
    
    AVPlayerItemAccessLogEvent *event = [events lastObject];
    
    return event.indicatedBitrate;
}

-(void)setBlock:(BOOL)flag
{
    [NSException raise:@"NotImplementedException" format:@"This function is not available in this version of the player"];
}
-(void)setPreferredZoomSetting:(NSString*)zoom
{
    [NSException raise:@"NotImplementedException" format:@"This function is not available in this version of the player"];
}
-(void)setClosedCaptionEnabled:(BOOL)enabled
{
    [_player setClosedCaptionDisplayEnabled:enabled];
}
-(void)setClosedCaptionTrack:(PlayerClosedCaptionTrack*)track
{
    [_player.currentItem selectSubtitleOption:[track getMediaSelectionOption]];
}

-(NSArray*)getClosedCaptionTracks
{
    NSMutableArray *ccTracksArray = [[NSMutableArray alloc] init];
    NSArray *subtitleOptions = [_player.currentItem subtitlesOptions];
    for (PTMediaSelectionOption *option in subtitleOptions)
    {
        PlayerClosedCaptionTrack *closedCaptionTrack = [[PlayerClosedCaptionTrack alloc] initWithPTMediaSelectionOption:option];
        [ccTracksArray addObject:closedCaptionTrack];
    }
    
    return ccTracksArray;
}
-(void)setClosedCaptionOptions:(PTTextStyleRule*)ccStyle
{
    PTMediaPlayerItem *currentItem = [_player currentItem];
    
    if(currentItem != nil)
    {
        [currentItem setCcStyle:ccStyle];
    }
}
-(void)setPreferredAudioLanguage:(PlayerAudioTrack*)audioOption
{
    [_player.currentItem selectAudioOption:[audioOption getMediaSelectionOption]];
}
-(NSArray*)getAvailableAudioLanguages
{
    NSArray *ptOptions = _player.currentItem.audioOptions;
    NSMutableArray *ppOptions = [[NSMutableArray alloc] init];
    for (PTMediaSelectionOption *option in ptOptions) {
        PlayerAudioTrack *track = [[PlayerAudioTrack alloc] initWithPTMediaSelectionOption:option];
        [ppOptions addObject:track];
    }
    return ppOptions;
}
-(void)setDimensionsOfVideo:(CGFloat)width height:(CGFloat)height
{
    CGRect playerRect = ((UIView *)[self getView]).frame;
    playerRect.origin = CGPointMake(0, 0);
    playerRect.size = CGSizeMake(width, height);
    
    [((UIView *)[self getView]) setFrame:playerRect];
    
    [((UIView *)[self getView]) setAutoresizingMask:( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight )];
}
-(void)setAutoPlay:(bool)flag
{
    _autoPlay = flag;
}
-(BOOL)getAutoPlay
{
    return _autoPlay;
}

-(Asset*)getCurrentAsset
{
    return _currentAsset;
}

-(void)setCurrentTimeUpdateInterval:(NSInteger*)interval
{
    _updateInterval = *interval;
}

-(void)configureAnalytics:(NSString*)analyticsUrl withProtocol:(NSString*)protocol withDeviceType:(NSString*)deviceType withDeviceId:(NSString*)deviceId
{
    _xuaPlayerParams = [[XuaPlayerParams alloc] init];
    [_xuaPlayerParams setParams:protocol withDeviceId:deviceId withDeviceType:deviceType];
    [[AnalyticsProvider sharedInstance] configureAnalytics:_xuaPlayerParams withUrl:analyticsUrl];
}

-(void)configureAuditudeAds:(NSString *)zoneId domain:(NSString *)domain
{
    _adZoneId = zoneId;
    _adDomain = domain;
}

-(void)setInitialBitrate:(int)initial
{
    _initialBitrate = initial;
}

-(void)setBitrateRange:(int)min max:(int)max
{
    _minBitrate = min;
    _maxBitrate = max;
}

-(void)setPlaybackRate:(float)rate;
{
    [_player setRate:rate];
}

- (void) onMediaPlayerStatusChange:(NSNotification *)notification
{
    NSString *result = @"";
    PTMediaError *error;

    switch([[notification.userInfo objectForKey:PTMediaPlayerStatusKey] intValue])
    {
        case PTMediaPlayerStatusCompleted:
            result = @"Completed";
            break;
        case PTMediaPlayerStatusCreated:
            result = @"Created";
            break;
        case PTMediaPlayerStatusError:
            error = self.player.error;
            result = @"Error";
            break;
        case PTMediaPlayerStatusInitialized:
            result = @"Initialized";
            break;
        case PTMediaPlayerStatusInitializing:
            result = @"Initializing";
            break;
        case PTMediaPlayerStatusPaused:
            result = @"Paused";
            break;
        case PTMediaPlayerStatusPlaying:
            result = @"Playing";
            break;
        case PTMediaPlayerStatusReady:
            result = @"Ready";
            break;
        case PTMediaPlayerStatusStopped:
            result = @"Stopped";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    if(error)
    {
//        if([[self convertPTMediaErrorCode:_player.error.code] isEqualToString:@"PTMediaErrorCodeDRMPlayFailed"])
//        {
//            return;
//        }
        
        PlayerPlatformMediaFailedEventData* eventData = [[PlayerPlatformMediaFailedEventData alloc] init];
        eventData.code = [NSString stringWithFormat:@"%d",error.code];
        eventData.description = error.description;
        
        NSLog(@"Media Player error. Code: %@ Description: %@",eventData.code,eventData.description);
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:MEDIA_FAILED
                                          object:self
                                        userInfo:[eventData toDictionary]];    }
    else
    {
        PlayerPlatformMediaPlayStateChangedEventData* eventData = [[PlayerPlatformMediaPlayStateChangedEventData alloc] init];
        eventData.playState = result;
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:PLAY_STATE_CHANGED
                                          object:self
                                        userInfo:[eventData toDictionary]];
        
        if([[notification.userInfo objectForKey:PTMediaPlayerStatusKey] intValue] == PTMediaPlayerStatusReady)
        {
            if(_autoPlay && _drmComplete && !_isStopped)
            {
                [_player play];
            }
            
            if(_isStopped)
            {
                [_player stop];
            }
        }
    }
}

-(void)removedDRMString
{
    _currentAsset.manifestUrl = [_currentAsset.manifestUrl stringByReplacingOccurrencesOfString:@"?faxs=1" withString:@""];
    _currentAsset.manifestUrl = [_currentAsset.manifestUrl stringByReplacingOccurrencesOfString:@"&faxs=1" withString:@""];
    
    PTMediaPlayerItem *item = [[PTMediaPlayerItem alloc] initWithUrl:[NSURL URLWithString:_currentAsset.manifestUrl]
                                                             mediaId:[_currentAsset.contentOptions valueForKey:MEDIA_ID]
                                                            metadata:nil];
    item.secure = NO;
    
    if (!_isStopped) {
        [_player replaceCurrentItemWithPlayerItem:item];
        [_player prepareToPlay];
    }
}


-(void)onAdBreakStarted:(NSNotification*)notification
{
    PlayerPlatformAdBreakStartedEventData *data = [[PlayerPlatformAdBreakStartedEventData alloc] init];
    PTAdBreak *adBreak = [notification.userInfo objectForKey:PTMediaPlayerAdBreakKey];
    if (adBreak != nil)
    {
        data.adBreak = [[VideoAdBreak alloc] initWithVideoAdBreak:adBreak];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_BREAK_STARTED object:self userInfo:[data toDictionary]];
}

-(void)onAdBreakCompleted:(NSNotification*)notification
{
    PlayerPlatformAdBreakCompleteEventData *data = [[PlayerPlatformAdBreakCompleteEventData alloc] init];
    PTAdBreak *adBreak = [notification.userInfo objectForKey:PTMediaPlayerAdBreakKey];
    if (adBreak != nil)
    {
        data.adBreak = [[VideoAdBreak alloc] initWithVideoAdBreak:adBreak];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_BREAK_COMPLETE object:self userInfo:[data toDictionary]];
}

-(void)onAdStarted:(NSNotification*)notification
{
    PlayerPlatformAdPlayStartedEventData *data = [[PlayerPlatformAdPlayStartedEventData alloc] init];
    PTAd *ad = [notification.userInfo objectForKey:PTMediaPlayerAdKey];
    if (ad != nil)
    {
        data.ad = [[VideoAd alloc] initWithAd:[notification.userInfo objectForKey:PTMediaPlayerAdKey]];;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_PLAY_STARTED object:self userInfo:[data toDictionary]];
}

-(void)onAdProgress:(NSNotification*)notification
{
    PlayerPlatformAdPlayProgressEventData *data = [[PlayerPlatformAdPlayProgressEventData alloc] init];
    PTAd *ad = [notification.userInfo objectForKey:PTMediaPlayerAdKey];
    CMTime progress =  [(NSValue *)[notification.userInfo objectForKey:PTMediaPlayerAdProgressKey] CMTimeValue];
    if (ad != nil)
    {
        VideoAd *videoAd = [[VideoAd alloc] initWithAd:[notification.userInfo objectForKey:PTMediaPlayerAdKey]];
        data.ad = videoAd;
        data.progress = progress;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_PLAY_PROGRESS object:self userInfo:[data toDictionary]];
}

-(void)onAdCompleted:(NSNotification*)notification
{
    PlayerPlatformAdPlayCompleteEventData *data = [[PlayerPlatformAdPlayCompleteEventData alloc] init];
    PTAd *ad = [notification.userInfo objectForKey:PTMediaPlayerAdKey];
    if (ad != nil)
    {
        VideoAd *videoAd = [[VideoAd alloc] initWithAd:[notification.userInfo objectForKey:PTMediaPlayerAdKey]];
        data.ad = videoAd;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_PLAY_COMPLETE object:self userInfo:[data toDictionary]];
}

- (void) onMediaPlayerItemChanged:(NSNotification *)notification
{
    if ([_currentAsset.manifestUrl rangeOfString:@"faxs=1"].location == NSNotFound ) {
        _drmComplete = true;
        
        if(_autoPlay && !_isStopped)
        {
            [_player play];
        }
    }
    else
    {
        NSLog(@"Key: %@", [[_currentAsset contentOptions] objectForKey:DRM_KEY]);
        NSArray *array = [[NSArray alloc] initWithObjects:_currentAsset, nil];
        [[DRMProvider sharedInstance] setAssets:array withWorkflow:PASSTHROUGH isOffline:false];
    }


    
    PlayerPlatformMediaChangedEventData* eventData = [[PlayerPlatformMediaChangedEventData alloc] init];
    eventData.currentUrl = _currentAsset.manifestUrl;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_CHANGED
                                      object:self
                                    userInfo:[eventData toDictionary]];
}



- (void) onMediaPlayerItemPlayStarted:(NSNotification *)notification
{
    PlayerPlatformMediaOpenedEventData* eventData = [[PlayerPlatformMediaOpenedEventData alloc]init];
    
    eventData.mediaType = @"VOD";
    eventData.description = @"Media Opened";
    eventData.playbackSpeeds = [[NSArray alloc]initWithObjects:[[NSNumber alloc] initWithDouble:0.0],
                                [[NSNumber alloc] initWithDouble:1.0],
                                [[NSNumber alloc] initWithDouble:0.0],
                                nil];
    eventData.availableAudioLanguages = [[NSArray alloc]init];
    
    //NSLog(@"Media Player Item Started. mediaType: %@, description: %@",eventData.mediaType,eventData.description);
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_OPENED
                                      object:self
                                    userInfo:[eventData toDictionary]];
    
    
}

- (void) onMediaPlayerItemPlayCompleted:(NSNotification *) notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_ENDED
                                      object:self];
}

- (void) onMediaPlayerTimeChange:(NSNotification *)notification
{
    PlayerPlatformMediaProgressEventData* eventData = [[PlayerPlatformMediaProgressEventData alloc] init];
    eventData.position = [NSNumber numberWithFloat:CMTimeGetSeconds(self.getCurrentPosition)];
    eventData.endPosition = [NSNumber numberWithDouble:CMTimeGetSeconds(self.getEndPosition)];
    eventData.startPosition = [NSNumber numberWithDouble:CMTimeGetSeconds(self.getStartPosition)];
    eventData.playbackSpeed = [NSNumber numberWithDouble:self.getCurrentPlaybackSpeed];
    
    [self checkLatestBitrate];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_PROGRESS
                                      object:self
                                    userInfo:[eventData toDictionary]];
}

- (void)onMediaPlayerNotificationItemEntry:(NSNotification *)nsnotification
{
    PTNotification *notification = [nsnotification.userInfo objectForKey:PTMediaPlayerNotificationKey];
    NSLog(@"Notification - media player notification code[%d], description[%@], metadata[%@].", notification.code, notification.description, notification.metadata);
}

-(void) onDrmComplete:(NSNotification *) notification
{
    _drmComplete = true;
    if(_autoPlay && !_isStopped)
    {
        [_player play];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DRM_COMPLETE object:self userInfo:[notification userInfo]];
}

-(void) onDrmFailure:(NSNotification *) notification
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[notification userInfo]];
    PlayerPlatformDrmFailureEventData *data = [[PlayerPlatformDrmFailureEventData alloc] init];
    [data fromDictionary:dict];
    if([data.major integerValue] == 3363)
    {
        if ([_currentAsset.manifestUrl rangeOfString:@"faxs=1"].location == NSNotFound) {
            _drmComplete = true;

            if(_autoPlay && !_isStopped)
            {
                [_player play];
            }
        }
        else
        {
            [self removedDRMString];
        }
        
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DRM_FAILURE object:self userInfo:[notification userInfo]];
    }
}

-(PTMediaError*)getError
{
    return _player.error;
}

-(NSString*)primeTimeStatusToString:(PTMediaPlayerStatus) status
{
    NSString* string = @"";
    
    switch(status)
    {
        case PTMediaPlayerStatusCompleted:
            string = @"Completed";
            break;
        case PTMediaPlayerStatusCreated:
            string = @"Created";
            break;
        case PTMediaPlayerStatusError:
            string = @"Error";
            break;
        case PTMediaPlayerStatusInitialized:
            string = @"Initialized";
            break;
        case PTMediaPlayerStatusInitializing:
            string = @"Initializing";
            break;
        case PTMediaPlayerStatusPaused:
            string = @"Paused";
            break;
        case PTMediaPlayerStatusPlaying:
            string = @"Playing";
            break;
        case PTMediaPlayerStatusReady:
            string = @"Ready";
            break;
        case PTMediaPlayerStatusStopped:
            string = @"Stopped";
            break;
    }
    
    return string;
}
-(AVPlayer*)getAVPlayer
{
    PTMediaPlayerView* ptView = [self getView];
    AVPlayer *player = [ptView player];
    return player;
}

-(void)initHeartbeatTimer
{
    if(!_heartbeatEnabled)
    {
        _heartbeatInterval = [[[ConfigurationManager sharedInstance] getConfigValue:HEARTBEAT_INTERVAL] integerValue];
        _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:_heartbeatInterval target:self selector:@selector(onHeartbeatTimer) userInfo:nil repeats:YES];
        _heartbeatEnabled = true;
    }
}

-(void)releaseHeartbeatTimer
{
    [_heartbeatTimer invalidate];
    _heartbeatTimer= nil;
    _heartbeatEnabled = false;
}

-(void)authenticateAsset:(Asset *)asset
{
    NSArray *array = [[NSArray alloc] initWithObjects:asset, nil];
    DRMProvider *provider = [DRMProvider sharedInstance];
    [provider setAssets:array withWorkflow:PASSTHROUGH isOffline:true];
}

-(void)checkLatestBitrate
{
    double currentBitrate;
    @try
    {
        AVPlayerItemAccessLogEvent *event = _player.view.player.currentItem.accessLog.events.lastObject;
        currentBitrate = event.indicatedBitrate;
        if(_latestBitrate != currentBitrate)
        {
            _latestBitrate = currentBitrate;
            PlayerPlatformBitrateChangedEventData* eventData = [[PlayerPlatformBitrateChangedEventData alloc] init];
            eventData.bitrate = [NSNumber numberWithDouble:_latestBitrate];
            eventData.description = BITRATE_CHANGED;
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:BITRATE_CHANGED
                                              object:self
                                            userInfo:[eventData toDictionary]];
        }
    }
    @catch (NSException *e){
        //Not throwing error because bitrate values may not be set
    }
}

-(void) onHeartbeatTimer
{
    @try {
        XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
        eventData.name = @"xuaHeartBeat";
        CMTime currentPosition = [self getCurrentPosition];
        eventData.currentPosition =  CMTimeGetSeconds(currentPosition) * 10000;
        eventData.bitrate =[[NSNumber numberWithDouble:[self getBitrate]] integerValue];
        eventData.playerState = [self getPlayerStatus];
        NSInteger timeStamp = [[self getTimeStamp] integerValue];
    
     //   NSLog(@"QoSHeartbeat event received -  timestamp: %d url: %@ videoPosition: %f playerState: %@ bitrate: %f",timeStamp, [[self getCurrentAsset] manifestUrl],CMTimeGetSeconds([self getCurrentPosition]),[self getPlayerStatus],[self getBitrate]);
   
    
        HeartbeatMessage *hbMessage = [[HeartbeatMessage alloc] initWithTimeStamp: timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
        [[AnalyticsProvider sharedInstance] buildMessage:hbMessage];
    }
   @catch (NSException * e) {
       NSLog(@"Cannot generate heartbeat, playback not started yet");
    }
    
}



-(NSNumber*)getTimeStamp
{
    return [NSNumber numberWithDouble:([NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970)];
}

-(void)sendOpeningMessage
{
    XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
    eventData.name = @"xuaOpeningMedia";
    NSInteger timeStamp = [[self getTimeStamp] integerValue];
    OpeningMediaMessage *openingMediaMessage = [[OpeningMediaMessage alloc] initWithTimestamp:timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
    [[AnalyticsProvider sharedInstance] buildMessage:openingMediaMessage];
}

-(PTMetadata*)generateAssetMetadata
{
    PTMetadata* metadata = nil;
    
    if(_adDomain != nil && _adZoneId != nil)
    {
        NSLog(@"Here");
        metadata = [[PTMetadata alloc] init];
        PTAuditudeMetadata *auditudeMetadata = [[PTAuditudeMetadata alloc] init];
        auditudeMetadata.zoneId = [_adZoneId integerValue];
        auditudeMetadata.domain = _adDomain;
        
        //NSMutableDictionary *targetingParameters = [[NSMutableDictionary alloc] init];
        //[targetingParameters setValue:@"androidpts" forKey:@"plr"];
        //auditudeMetadata.targetingParameters = targetingParameters;
        [metadata setMetadata:auditudeMetadata forKey:PTAdResolvingMetadataKey];
    }
    
    if(metadata == nil)
    {
        metadata = [[PTMetadata alloc] init];
    }
    
    PTABRControlParameters *abrMetaData = [[PTABRControlParameters alloc] initWithABRControlParameters:_initialBitrate minBitRate:_minBitrate maxBitRate:_maxBitrate];
    [metadata setMetadata:abrMetaData forKey:PTABRResolvingMetadataKey];
    return metadata;
}

@end
