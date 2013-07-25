//
//  XvidPlayer.m
// PlayerPlatform
//
//  Created by Cory Zachman on 6/1/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <CoreMedia/CoreMedia.h>
#import "PlayerPlatformAPI.h"
#import "PrimeTimePlayer.h"
#import "PlayerPlatformVideoEvent.h"
#import "PlayerPlatformVideoEventData.h"
#import "PlayerPlatformMediaOpenedEventData.h"
#import "PlayerPlatformMediaFailedEventData.h"
#import "PlayerPlatformMediaProgressEventData.h"
#import "PlayerPlatformMediaPlayStateChangedEventData.h"
#import "PTMediaError.h"
#import "PTMediaPlayerNotifications.h"
#import "PTMediaPlayerItem.h"
#import "AssetBuilder.h"
#import "EmergencyAlertProvider.h"
#import "DRMProvider.h"

@interface PlayerPlatformAPI ()
{
    PrimeTimePlayer *_playerPlatform;
    long long latency;
    bool opened;
}
@end

@implementation PlayerPlatformAPI

/**
 * Initializes the Player Platform API Wrapper
 */
-(id)init
{
    self = [super init];
    if(self)
    {
        _playerPlatform = [[PrimeTimePlayer alloc] init];
        [[DRMProvider sharedInstance] initializeDrmManager];
        opened = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerError:) name:MEDIA_FAILED object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerTimeChange:) name:MEDIA_PROGRESS object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerStatusChange:) name:PLAY_STATE_CHANGED object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemPlayStarted:) name:MEDIA_OPENED object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemPlayCompleted:) name:MEDIA_ENDED object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerItemChanged:) name:MEDIA_CHANGED object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaPlayerBitrateChanged:) name:BITRATE_CHANGED object:_playerPlatform];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmComplete:) name:DRM_COMPLETE object:_playerPlatform];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDrmFailure:) name:DRM_FAILURE object:_playerPlatform];

    }
    return self;
}

/**
 * Destroys Player Platform API Wrapper
 */
-(void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_FAILED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_PROGRESS object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PLAY_STATE_CHANGED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_OPENED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_ENDED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEDIA_CHANGED object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BITRATE_CHANGED object:_playerPlatform];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_COMPLETE object:_playerPlatform];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DRM_FAILURE object:_playerPlatform];

    [[EmergencyAlertProvider sharedInstance] deactivatePolling];
    [_playerPlatform destroy];
    _playerPlatform = nil;
    
}

/**
 * Returns autoplay
 */
-(BOOL)getAutoPlay
{
    return [_playerPlatform getAutoPlay];
}

-(UIView*)getView
{
    return ((UIView *)[_playerPlatform getView]);
}

-(void)setContentURL:(NSString *)stringUrl withContentOptions:(NSDictionary *)contentOptions
{    
    latency = [[[NSDate alloc] init] timeIntervalSince1970];
    [_playerPlatform setContentURL:stringUrl withContentOptions:contentOptions];
}

-(CMTimeRange)getSeekableTimeRange
{
    return [_playerPlatform getSeekableTimeRange];
}

-(void)changeAsset:(Asset *)asset
{
    [_playerPlatform changeAsset:asset];
}

-(void)setClosedCaptionOptions:(PTTextStyleRule*)ccStyle
{
    [_playerPlatform setClosedCaptionOptions:ccStyle];
}

-(void)setInitialBitrate:(int)initial
{
    [_playerPlatform setInitialBitrate:initial];
}

-(void)setBitrateRange:(int)min max:(int)max
{
    [_playerPlatform setBitrateRange:min max:max];
}

-(int)getInitialBitrate
{
    return [_playerPlatform getInitialBitrate];
}

-(NSArray*)getBitrateRange
{
    return [_playerPlatform getBitrateRange];
}

-(double)getBitrate
{
    return [_playerPlatform getBitrate];
}

-(NSArray*)getClosedCaptionTracks
{
    return [_playerPlatform getClosedCaptionTracks];
}

-(void)play
{
    [_playerPlatform play];
}

-(Asset*)getCurrentAsset
{
    return [_playerPlatform getCurrentAsset];
}

-(void)pause
{
    [_playerPlatform pause];
}

-(void)stop
{
    [_playerPlatform stop];
}

-(void)reset
{
    [_playerPlatform reset];
}

-(void)seekToLive
{
    [_playerPlatform seekToLive];
}

-(BOOL)isDrmProtected
{
    return [_playerPlatform isDrmProtected];
}

-(void)setPosition:(CMTime)seconds
{
    [_playerPlatform setPosition:seconds];
}

-(void)setPosition:(CMTime)time completionHandler:(void (^)(BOOL))completionHandler
{
    [_playerPlatform setPosition:time completionHandler:completionHandler];
}

-(void)setPositionRelative:(CMTime)position
{
    [_playerPlatform setPositionRelative:position];
}

-(void)setVolume:(NSInteger*)volume
{
    [_playerPlatform setVolume:volume];
}

-(NSArray*)getSupportedPlaybackSpeeds
{
    return [_playerPlatform getSupportedPlaybackSpeeds];
}

-(void)setSpeed:(CGFloat)speed withOvershootCorrection:(CGFloat)overshootCorrection
{
    [_playerPlatform setSpeed:speed withOvershootCorrection:overshootCorrection];
}

-(CGFloat)getCurrentPlaybackSpeed
{
    return [_playerPlatform getCurrentPlaybackSpeed];
}

-(void)setBlock:(BOOL)flag
{
    [_playerPlatform setBlock:flag];
}

-(void)setPreferredZoomSetting:(NSString*)zoom
{
    [_playerPlatform setPreferredZoomSetting:zoom];
}

-(void)setClosedCaptionEnabled:(BOOL)enabled
{
    [_playerPlatform setClosedCaptionEnabled:enabled];
}

-(void)setClosedCaptionTrack:(PlayerClosedCaptionTrack*)track
{
    [_playerPlatform setClosedCaptionTrack:track];
}

-(void)setPreferredAudioLanguage:(PlayerAudioTrack*)audioOption
{
    [_playerPlatform setPreferredAudioLanguage:audioOption];
}

-(NSArray*)getAvailableAudioLanguages
{
    return [_playerPlatform getAvailableAudioLanguages];
}

-(void)setAutoPlay:(BOOL)flag
{
    _playerPlatform.autoPlay = flag;
}

-(void)setCurrentTimeUpdateInterval:(NSInteger*)interval
{
    [_playerPlatform setCurrentTimeUpdateInterval:interval];
}

-(void)requestMediaProgress
{
    [self onMediaPlayerTimeChange:nil];
}

-(void)setDimensionsOfVideo:(CGFloat)width height:(CGFloat)height
{
    [_playerPlatform setDimensionsOfVideo:width height:height];
}

-(CMTime)getEndPosition
{
    return [_playerPlatform getEndPosition];
}

-(CMTime)getDuration
{
    return [_playerPlatform getDuration];
}

-(CMTime)getStartPosition
{
    return [_playerPlatform getStartPosition];
}

-(CMTime)getCurrentPosition
{
    return [_playerPlatform getCurrentPosition];
}

-(NSString*)getPlayerStatus
{
    return [_playerPlatform getPlayerStatus];
}

-(BOOL)getClosedCaptionStatus
{
    return [_playerPlatform getClosedCaptionStatus];
}

-(void)configureAnalytics:(NSString*)analyticsUrl withProtocol:(NSString*)protocol withDeviceType:(NSString*)deviceType withDeviceId:(NSString*)deviceId
{
    [_playerPlatform configureAnalytics:analyticsUrl withProtocol:protocol withDeviceType:(NSString*)deviceType withDeviceId:(NSString *)deviceId];
}

-(void)configureAnalyticsWithDeviceId:(NSString*)deviceId
{
    [self configureAnalytics:[[ConfigurationManager sharedInstance] getConfigValue:ANALYTICS_ENDPOINT] withProtocol:[[ConfigurationManager sharedInstance] getConfigValue:ANALYTICS_PROTOCOL] withDeviceType:[[ConfigurationManager sharedInstance] getConfigValue:ANALYTICS_DEVICE_TYPE] withDeviceId:deviceId];
    
}

-(void)configureAlertProvider:(NSString*) tokenToFipsUrl alertServiceUrl:(NSString*)alertServiceUrl token:(NSString*)token settings:(EmergencyAlertSettings *)settings
{
    EmergencyAlertProvider *emergencyAlertProvider = [EmergencyAlertProvider sharedInstance];
    [emergencyAlertProvider configureAlertProvider:tokenToFipsUrl alertServiceUrl:alertServiceUrl token:token settings:settings ];
    [emergencyAlertProvider setPlayerPlatform:self];
}

-(void)configureAlertProviderWithToken:(NSString*)token
{
    EmergencyAlertProvider *emergencyAlertProvider = [EmergencyAlertProvider sharedInstance];
    [emergencyAlertProvider configureAlertProvider:[[ConfigurationManager sharedInstance] getConfigValue:ZIP_TO_FIPS_ENDPOINT] alertServiceUrl:[[ConfigurationManager sharedInstance] getConfigValue:ALERT_SERVICE_ENDPOINT] token:token settings:[[EmergencyAlertSettings alloc] init]];
    [emergencyAlertProvider setPlayerPlatform:self];
}

-(void)configureAuditudeAds
{
    [_playerPlatform configureAuditudeAds:[[ConfigurationManager sharedInstance] getConfigValue:ZONE_ID] domain:[[ConfigurationManager sharedInstance] getConfigValue:DOMAIN_ID]];
}

-(void)configureAuditudeAds:(NSString *)zoneId domain:(NSString *)domain
{
    [_playerPlatform configureAuditudeAds:zoneId domain:domain];
}

-(void)authenticateAsset:(Asset *)asset
{
    [_playerPlatform authenticateAsset:asset];
}

-(AVPlayer*)getAVPlayer
{
    return [_playerPlatform getAVPlayer];
}

-(NSNumber*)getTimeStamp
{
    return [NSNumber numberWithDouble:([NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970)];
}

-(NSString*)primeTimeStatusToString:(PTMediaPlayerStatus) status
{
    return [_playerPlatform primeTimeStatusToString:status];
}

#pragma mark -
#pragma mark Media Player Notifications

- (void)onMediaPlayerError:(NSNotification *)notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_FAILED object:self userInfo:[notification userInfo]];
    
    PlayerPlatformMediaFailedEventData *data = [[PlayerPlatformMediaFailedEventData alloc] init];
    [data fromDictionary:[notification userInfo]];
    XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
    eventData.name = @"xuaMediaFailed";
    eventData.failureCode = data.code;
    eventData.failureDescription = data.description;
    NSInteger timeStamp = [[self getTimeStamp] integerValue];

    MediaFailedMessage *mediaFailedMessage = [[MediaFailedMessage alloc] initWithTimestamp:timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
    [[AnalyticsProvider sharedInstance] buildMessage:mediaFailedMessage];
    [[AnalyticsProvider sharedInstance] forceSendMessage];
}

- (void) onMediaPlayerTimeChange:(NSNotification *)notification
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_PROGRESS object:self userInfo:[notification userInfo]];
}

- (void) onMediaPlayerStatusChange:(NSNotification *)notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:PLAY_STATE_CHANGED object:self userInfo:[notification userInfo]];
    
    PlayerPlatformMediaPlayStateChangedEventData *data = [[PlayerPlatformMediaPlayStateChangedEventData alloc] init];
    [data fromDictionary:[notification userInfo]];
        
    XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
    eventData.name = @"xuaPlayStateChanged";
    eventData.playerState = data.playState;
    NSInteger timeStamp = [[self getTimeStamp] integerValue];

    PlayStateChangedMessage *playStateChangedMessage = [[PlayStateChangedMessage alloc] initWithTimestamp:timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
    [[AnalyticsProvider sharedInstance] buildMessage:playStateChangedMessage];
    
}

- (void) onMediaPlayerItemPlayStarted:(NSNotification *)notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_OPENED object:self userInfo:[notification userInfo]];
    
    if(!opened)
    {
        XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
        eventData.name = @"xuaMediaOpened";
        eventData.currentPosition = 0;
        eventData.assetOpeningTime = [[NSNumber numberWithDouble:([[[NSDate alloc] init] timeIntervalSince1970] - latency) ] integerValue];
        NSInteger timeStamp = [[self getTimeStamp] integerValue];

        MediaOpenedMessage *mediaOpenedMessage = [[MediaOpenedMessage alloc] initWithTimestamp:timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
        [[AnalyticsProvider sharedInstance] buildMessage:mediaOpenedMessage];
        opened = true;
    }
}

- (void) onMediaPlayerItemPlayCompleted:(NSNotification *) notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_ENDED object:self userInfo:[notification userInfo]];
}

-(void) onMediaPlayerItemChanged:(NSNotification *) notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:MEDIA_CHANGED object:self userInfo:[notification userInfo]];
}

-(void) onMediaPlayerBitrateChanged:(NSNotification*) notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:BITRATE_CHANGED object:self userInfo:[notification userInfo]];
    
    XAnalyticsEventData *eventData = [[XAnalyticsEventData alloc] init];
    eventData.name = @"xuaBitrateChanged";
    CMTime currentPosition = [self getCurrentPosition];
    eventData.currentPosition =  CMTimeGetSeconds(currentPosition);
    eventData.bitrate =[[NSNumber numberWithDouble:[self getBitrate]] integerValue];
    NSInteger timeStamp = [[self getTimeStamp] integerValue];

    BitrateChangedMessage *bitrateChangedMessage = [[BitrateChangedMessage alloc] initWithTimestamp:timeStamp withAnalyticsEvent:eventData withAsset:[[[AssetBuilder alloc] init] buildAsset:[self getCurrentAsset]]];
    [[AnalyticsProvider sharedInstance] buildMessage:bitrateChangedMessage];
}

-(void)onDrmComplete:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DRM_COMPLETE object:self userInfo:[notification userInfo]];
}

-(void)onDrmFailure:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DRM_FAILURE object:self userInfo:[notification userInfo]];
}

@end
