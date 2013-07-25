//
//  PrimeTimeXvid.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <drmNativeInterface/DRMInterface.h>
#import <PlayerPlatformAnalytics/PlayerPlatformAnalytics.h>
#import "IPlayerPlatform.h"
#import "PTMediaPlayer.h"
#import "Asset.h"
@class PrimeTimePlayer;

@interface PrimeTimePlayer : NSObject
@property (nonatomic, readonly, retain) PTMediaPlayer *player;
@property (nonatomic) int updateInterval;
@property (nonatomic) bool autoPlay;
@property (nonatomic) bool captionsEnabled;

-(void)destroy;
-(void)initQos;
-(void)changeAsset:(Asset *)asset;
-(void)play;
-(void)pause;
-(void)stop;
-(void)reset;
-(void)setContentURL:(NSString *)url withContentOptions:(NSDictionary *)contentOptions;
-(void)seekToLive;
-(void)setPosition:(CMTime)seconds;
-(void)setPosition:(CMTime)time completionHandler:(void (^)(BOOL))completionHandler;
-(void)setPositionRelative:(CMTime)seconds;
-(NSArray*)getSupportedPlaybackSpeeds;
-(CMTime)getEndPosition;
-(CMTime)getStartPosition;
-(CMTime)getCurrentPosition;
-(CMTime)getDuration;
-(BOOL)isDrmProtected;
-(PTMediaPlayerView*)getView;
-(void)setSpeed:(CGFloat)speed withOvershootCorrection:(CGFloat)overshootCorrection;
-(void)setVolume:(NSInteger*)volume;
-(CGFloat)getCurrentPlaybackSpeed;
-(NSString*)getPlayerStatus;
-(BOOL)getClosedCaptionStatus;
-(NSArray*)getBitrateRange;
-(int)getInitialBitrate;
-(double)getBitrate;
-(void)setBlock:(BOOL)flag;
-(void)setPreferredZoomSetting:(NSString*)zoom;
-(void)setClosedCaptionEnabled:(BOOL)enabled;
-(void)setClosedCaptionTrack:(PlayerClosedCaptionTrack*)track;
-(NSArray*)getClosedCaptionTracks;
-(void)setClosedCaptionOptions:(PTTextStyleRule*)ccStyle;
-(void)setPreferredAudioLanguage:(PlayerAudioTrack*)audioOption;
-(NSArray*)getAvailableAudioLanguages;
-(void)setDimensionsOfVideo:(CGFloat)width height:(CGFloat)height;
-(void)setAutoPlay:(bool)flag;
-(BOOL)getAutoPlay;
-(Asset*)getCurrentAsset;
-(void)setCurrentTimeUpdateInterval:(NSInteger*)interval;
-(void)configureAnalytics:(NSString*)analyticsUrl withProtocol:(NSString*)protocol withDeviceType:(NSString*)deviceType withDeviceId:(NSString*)deviceId;
-(void)configureAuditudeAds:(NSString *)zoneId domain:(NSString *)domain;
-(void)setInitialBitrate:(int)initial;
-(void)setBitrateRange:(int)min max:(int)max;
-(void)setPlaybackRate:(float)rate;
-(void)authenticateAsset:(Asset *)asset;
-(NSString*)primeTimeStatusToString:(PTMediaPlayerStatus) status;
-(AVPlayer*)getAVPlayer;
-(CMTimeRange)getSeekableTimeRange;

@end
