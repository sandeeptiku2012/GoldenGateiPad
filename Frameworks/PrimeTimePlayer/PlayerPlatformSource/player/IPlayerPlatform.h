 //
//  IXvidPlayer.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 6/4/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import "Asset.h"
#import "EmergencyAlertSettings.h"
#import "PlayerAudioTrack.h"
#import "PTMediaPlayerView.h"
#import "PTTextStyleRule.h"
#import "PlayerClosedCaptionTrack.h"
#import "PTMediaPlayer.h"

@protocol IPlayerPlatform <NSObject>

/** Initializes the Player Platform Object */
-(id)init;

/** Destroys the Player Platform Object */
-(void)destroy;

/** Play the current asset. Play will use the set playback speed */
-(void)play;

/** Pause the current asset. The asset can be resumed by calling play() */
-(void)pause;

/** Stops the current asset and resets the player. In order to play the asset again, the setContentUrl() function must be called. */
-(void)stop;

/** Resets the player. Destroys the current Item and clears the status to "Created". */
-(void)reset;

/** */
-(BOOL)isDrmProtected;

/** Set the manifest url and metadata describing the asset
    @param url The FQDN of the asset's manifest location
    @param contentOptions The complex data type containing all metadata for the asset
 
 */
-(void)setContentURL:(NSString *)url withContentOptions:(NSDictionary *)contentOptions;

/** @name Properties */
/**
 * The playback range of a stream or empty if the stream is not processed yet.
 * This range includes the duration of any additional content inserted into the stream (ex: ads).
 */
-(CMTimeRange)getSeekableTimeRange;

/**
 * Sets the play head to the current live point.
 * This will not be actual live as the player keeps a configurable distance away from live.
 */
-(void)seekToLive;

/**
 * Sets the play head position.
 *
 * @param seconds Desired play head position in seconds.
 */
-(void)setPosition:(CMTime)seconds;

/**
 * Initiates a seek to the specified time and executes the specified block when the seek operation has
 * either been completed or been interrupted.
 *
 * This method will not change the status of the MediaPlayer.
 * The seek operation is asynchronous. A notification will be dispatched
 * to signal the completion of the seek operation.
 */
- (void) setPosition:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

/**
 * Sets the play head position relative to the current play head position.
 *
 * @param seconds Desired play head position in seconds relative to the current play head position.
 * (newPosition = currentPosition + seconds)
 *
 */
-(void)setPositionRelative:(CMTime)seconds;

/**
 * Changes the current asset to the one passed in
 *
 * @param asset - the Asset to bind with the player
 */
-(void)changeAsset:(Asset*)asset;

/**
 * Returns the end poisiton of the asset in seconds.
 * @return End position of the asset in seconds.
 *
 */
-(CMTime)getEndPosition;

/**
 * Returns the start position of the asset in seconds.
 * @return Start posisiton of the asset in seconds.
 *
 */
-(CMTime)getStartPosition;

/**
 * Returns the play head position of the player in seconds.
 * @return Play head position of player in seconds.
 *
 */
-(CMTime)getCurrentPosition;

/**
 * Returns the duration of the asset in seconds.
 * @return Duration of the media in seconds.
 *
 */
-(CMTime)getDuration;

/**
 * Returns all suported playback speeds for the asset.
 * @return Array containing Doubles that represent suported playback speeds.
 *
 */
-(NSArray*)getSupportedPlaybackSpeeds;

/**
 * Returns the view associated with the current PTMediaPlayer. From this you can get the underlying AVPlayer
 * @return PTMediaPlayerView
 *
 */
-(PTMediaPlayerView*)getView;
-(void)setSpeed:(CGFloat)speed withOvershootCorrection:(CGFloat)overshootCorrection;

/**
 * Set the playback volume
 * @param volume The desired volume the value can be between 0 and 1
 *
 */
-(void)setVolume:(NSInteger*)volume;

/**
 * Returns current playback speed
 *
 */

-(CGFloat)getCurrentPlaybackSpeed;

/**
 * Returns the current player status.
 * @return Current player status. Possible values are: Completed, Created, Error, Initialized, Initializing
 * Paused, Playing, Ready
 */
-(NSString*)getPlayerStatus;

/**
 * Returns a boolean indicating the status of CC.
 * @return The current status of CC.
 *
 */
-(BOOL)getClosedCaptionStatus;

/**
 * Returns the initial bitrate
 *
 *
 */
-(int)getInitialBitrate;

/**
 * Sets the initial bitrate to load. Will default to the closest (equal or less) bitrate if they do not match exactly
 *
 * @param initial - initial bitrate to preload
 */
-(void)setInitialBitrate:(int)initial;

/**
 * Sets the bitrate range of the player
 * @param min - minimum bitrate
 * @param max - maximum bitrate
 */
-(void)setBitrateRange:(int)min max:(int)max;

/**
 * Returns the range of allowed profiles for video playback. The player stays with the range.
 * @return An NSArray contating the range [0] = min value, [1] = max value.
 * Array will be null if range was never set.
 *
 */
-(NSArray*)getBitrateRange;

/**
 * Returns the current bitrate that we are playing at
 *
 */
 
-(double)getBitrate;
-(void)setBlock:(BOOL)flag;
-(void)setPreferredZoomSetting:(NSString*)zoom;

/**
 * Sets the closed captioning option on the current asset
 * @param enabled - true to enabled CC, false to disable
 */
-(void)setClosedCaptionEnabled:(BOOL)enabled;

/**
 * Returns the available closed caption tracks. Call setClosedCaptionTrack to change tracks
 *
 * @return NSArray of available closed caption tracks as PlayerClosedCaptionTrack objects
 */
-(NSArray*)getClosedCaptionTracks;

/**
 * Sets the closed caption track
 *
 * @param PlayerClosedCaptionTrack
 */
-(void)setClosedCaptionTrack:(PlayerClosedCaptionTrack*)track;

/**
 * Sets the text style options for closed captioning
 * @param ccStyle - PTTextStyleRule object containing the style settings to use in CC rendering
 */
-(void)setClosedCaptionOptions:(PTTextStyleRule*)ccStyle;

/**
 * Set the preffered audio langauge use @see getAvailableAudioLanguages to get the acceptable values.
 *
 * @param audioOption - PlayerAudioTrack that was returned from the getAvailableAudioLanguages call
 */
-(void)setPreferredAudioLanguage:(PlayerAudioTrack*)audioOption;

/**
 * Returns the available audio languages
 *
 * @return NSArray of PlayerAudioTrack objects, one for each audio track
 */
-(NSArray*)getAvailableAudioLanguages;

/**
 * Request the player to fire a Media Progress event prior to timer firing it.
 *
 */
-(void)requestMediaProgress;

/**
 * Size of the video. Once the playback starts, the client can use this property to set the desired rendered video dimensions.
 * @param width The media width in pixels.
 * @param height The media height in pixels.
 *
 */
-(void)setDimensionsOfVideo:(CGFloat)width height:(CGFloat)height;

/**
 * Flag indicating if the player will automatically start playing the media stream once all the data is available. 
 * Defaults to false.
 * @param flag
 */
-(void)setAutoPlay:(BOOL)flag;

/**
 * Flag indicating if the player will automatically start playing the media stream once all the data is available. 
 * Defaults to false.
 * @return boolean value of autoPlay
 */
-(BOOL)getAutoPlay;

/**
 * Returns the current asset that is being handled by the player .
 *
 * @return current asset being played 
 */
-(Asset*)getCurrentAsset;


-(void)setCurrentTimeUpdateInterval:(NSInteger*)interval;

/**
 * Configures the player Analytics - Please contact christopher_lintz@cable.comcast.com for details on the url, protocol, deviceType, and deviceId
 * @param analyticsUrl - The url to send requests
 * @param protocol - protocal that your messages will be using
 * @param deviceType - deviceType as provided by the big data team
 * @param deviceId - deviceId as directed by the big data team
 *
 */
-(void)configureAnalytics:(NSString*)analyticsUrl withProtocol:(NSString*)protocol withDeviceType:(NSString*)deviceType withDeviceId:(NSString*)deviceId;

/**
 * Configures the player Analytics using the ConfigurationManager - Please contact christopher_lintz@cable.comcast.com for details on the url, protocol, deviceType, and deviceId
 * @param deviceId - deviceId as directed by the big data team
 *
 */
-(void)configureAnalyticsWithDeviceId:(NSString*)deviceId;

/**
 * Configures EAS Alert Provider. Contact cory_zachman@cable.comcast.com for information on what to input into this function
 * @param alertServiceUrl - url that new alerts will be available at 
 * @param token - XsctToken token
 * @param settings - EmergencyAlertSettings object
 */
-(void)configureAlertProvider:(NSString*) tokenToFipsUrl alertServiceUrl:(NSString*)alertServiceUrl token:(NSString*)token settings:(EmergencyAlertSettings*) settings;
/**
 * Configures EAS Alert Provider using the values currently Stored in the Configuration Manager
 * @param token - XsctToken token
 * @param settings - EmergencyAlertSettings object
 */
-(void)configureAlertProviderWithToken:(NSString*)token;

/**
 * Configures the player for use with Auditude ads
 * @param zoneId - the zoneId for auditude ads
 * @param domain - the domain for auditude ads
 */
-(void)configureAuditudeAds:(NSString*)zoneId domain:(NSString*) domain;

/**
 * Configures the player for use with Auditude ads using the Configuration
 * @param zoneId - the zoneId for auditude ads
 * @param domain - the domain for auditude ads
 */
-(void)configureAuditudeAds;

/**
 * Returns the underlying AVPlayer 
 *
 * @return the underlying AVPlayer 
 */
-(AVPlayer*)getAVPlayer;

/**
 * Authenticates the asset for offline playback. Currently only supports passthrough authentication
 * @param the Asset you wish to authenticate
 */
-(void)authenticateAsset:(Asset*)asset;

/**
 * Returns a string of the primeTimeStatus
 * @param status
 */
-(NSString*)primeTimeStatusToString:(PTMediaPlayerStatus) status;

@end
