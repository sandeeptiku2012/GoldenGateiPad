/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

//
//  PTMediaPlayer.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>
#import <drmNativeInterface/DRMInterface.h>


@class PTMetadata;
@class PTMediaPlayerItem;
@class PTMediaError;
@class PTMediaPlayerView;
@class PTMediaSelectionOption;

#pragma mark -
#pragma mark Enumeration values

enum
{
    PTMediaPlayerStatusCreated,
    PTMediaPlayerStatusInitializing,
    PTMediaPlayerStatusInitialized,
    PTMediaPlayerStatusReady,
    PTMediaPlayerStatusPlaying,
    PTMediaPlayerStatusPaused,
    PTMediaPlayerStatusStopped,
    PTMediaPlayerStatusCompleted,
    PTMediaPlayerStatusError
};
typedef NSInteger PTMediaPlayerStatus;

enum
{
    PTMediaPlayerVideoGravityNone,
    PTMediaPlayerVideoGravityResize,
    PTMediaPlayerVideoGravityResizeAspect,
};
typedef NSInteger PTMediaPlayerVideoGravity;

#pragma mark -
#pragma mark Notification types

extern NSString *const PTMediaPlayerNotificationKey;
extern NSString *const PTMediaPlayerStatusKey;
extern NSString *const PTMediaPlayerAdKey;
extern NSString *const PTMediaPlayerAdAssetKey;
extern NSString *const PTMediaPlayerAdClickURLKey;
extern NSString *const PTMediaPlayerAdBreakKey;
extern NSString *const PTMediaPlayerAdProgressKey;
extern NSString *const PTMediaPlayerTimelineKey;

#pragma mark -
#pragma mark Media Player 

/**
 * PTMediaPlayer class is the root component for the PMP framework. 
 *
 * Applications create an instance of this class to playback a media. Notifications are dispatched
 * by this component to let the application know about the status of the player at any given time.
 */
@interface PTMediaPlayer : NSObject

/** @name Logging */
/**
 * Toggles debug console logging from the SDK on or off.
 * Default is NO.
 *
 * @param enable YES to turn on debug messages logging to console and NO otherwise
 */
+ (void)enableDebugLog:(BOOL)enable;

/** @name Creating a Player */
/**
 * Convenience method to create a media player using a media player item.
 *
 * @param item The PTMediaPlayerItem instance to be used for playback
 */
+ (PTMediaPlayer *) playerWithMediaPlayerItem:(PTMediaPlayerItem *) item;

/** @name Creating a Player */
/**
 * Convenience method to create a media player using the specified url and metadata.
 *
 * @param url The url to be used for playback
 * @param mediaId The unique id associated with the current media
 * @param metadata The PTMetadata instance describing the metadata for the current media
 */
+ (PTMediaPlayer *) playerWithURL:(NSURL *)url mediaId:(NSString *)mediaId metadata:(PTMetadata *)metadata;

/** @name Creating a Player */
/**
 * Initializes the media player with the specified media player item.
 *
 * @param item The PTMediaPlayerItem instance to be used for playback 
 */
- (id) initWithMediaPlayerItem:(PTMediaPlayerItem *) item;

/** @name Creating a Player */
/**
 * Creates a media player using the specified url and metadata.
 *
 * @param url The url to be used for playback 
 * @param mediaId The unique id associated with the current media
 * @param metadata The PTMetadata instance describing the metadata for the current media 
 */
- (id) initWithURL:(NSURL *)url mediaId:(NSString *)mediaId metadata:(PTMetadata *)metadata;

/** @name Reset a Player */
/**
 * Resets the player. Destroys the current Item and clears the status to "Created".
 */
- (void)reset;

/** @name Properties */
/**
 * Indicates the current rate of playback; 0.0 means "stopped", 1.0 means "play at the natural rate of the current item" 
 */
@property (nonatomic) float rate;

/** @name Properties */
/**
 * Flag indicating if the player will automatically play the media after intialization.
 *
 * If the flag is TRUE, the framework will start playing the media stream once all the data is available.
 * If the flag is FALSE, the application must call play to start the media playback
 */
@property (nonatomic) BOOL autoPlay;

/** @name Properties */
/**
 * Returns the state of the player.
 *
 * This property is observable.
 */
@property (readonly, nonatomic) PTMediaPlayerStatus status;

#pragma mark -
#pragma mark Timeline management

/**
 * Media player duration.
 */
@property (readonly, nonatomic) CMTime duration;

/** @name Properties */
/**
 * Interval between the dispatch of change events for the current time
 * in milliseconds. 
 * <p>The default is 250 milliseconds.
 * A non-positive value disables the dispatch of the change events.</p>
 */
@property (nonatomic) NSTimeInterval currentTimeUpdateInterval;

/** @name Properties */
/**
 * The current playhead time as reported by the underlying components.
 * The playhead time is calculated relative to the resolved stream, one
 * which can contain multiple ads inserted.
 */
@property (readonly, nonatomic) CMTime currentTime;

/** @name Properties */
/**
 * The playback range of a stream or empty if the stream is not processed yet.
 * This range includes the duration of any additional content inserted into the stream (ex: ads).
 */
@property (readonly, nonatomic) CMTimeRange seekableRange;

/** @name Properties */
/**
 * The current playback item.
 */
@property (readonly, nonatomic, strong) PTMediaPlayerItem *currentItem;

/** @name Properties */
/**
 * The DRMManager instance associated with the content.
 *
 */
@property (readonly, nonatomic) DRMManager *drmManager;

/** @name Properties */
/**
 * The media player last error.
 *
 * When an error occurs the media player dispatches a notification
 * containing the error, but also saves it internally. 
 */
@property (readonly, nonatomic, strong) PTMediaError *error;

/** @name Properties */
/**
 * Returns whether the player is playing a linear ad.
 * 
 * @returns a BOOL indicating the current player is playing ad
 */
@property (readonly, nonatomic) BOOL isPlayingAd;

#pragma mark -
#pragma mark Video display management

/** @name Properties */
/**
 * The video view which will host the playback surface.
 * 
 * The client will use this property to position and resize
 * the video display.
 */
@property (readonly, nonatomic, strong) PTMediaPlayerView *view;

/** @name Properties */
/**
 * Scaling policy for video display.
 */
@property (nonatomic) PTMediaPlayerVideoGravity videoGravity; 

/** @name Properties */
/**
 * Indicates whether the player allows AirPlay video playback.
 *
 * Enable AirPlay by setting the allowsAirPlayVideo property to YES.
 * disable AirPlay, set the allowsAirPlayVideo property to NO.
 */
@property (nonatomic) BOOL allowsAirPlayVideo;

/** @name Properties */
/**
 * Indicates whether the display of subtitles is enabled or not
 *
 * Enable/Disable the display of CC by setting the closedCaptionDisplayEnabled property to YES/NO.
 */
@property (nonatomic, getter=isClosedCaptionDisplayEnabled) BOOL closedCaptionDisplayEnabled;

/** @name Managing Playback */
/**
 * Replaces the current media player item with the one specified.
 * 
 * The replacement is asynchronous. The client need to observe currentItem
 * property in order to detect when the replacement was completed. 
 *
 * @param item The PTMediaPlayerItem instance to be used for playback
 */
-(void)replaceCurrentItemWithPlayerItem:(PTMediaPlayerItem *)item;

#pragma mark -
#pragma mark Playback Management

/** @name Managing Playback */
/**
 * Prepares a movie for playback.
 *
 * If the client calls play  method directly and the media item is not
 * yet initialized or ready to play, the media player will invoked this method 
 * automatically. 
 */
- (void) prepareToPlay;

/** @name Managing Playback */
/**
 * Initiate the playback of the current media item.
 *
 * If the current media item was paused, then invoking this command
 * will resume the playback for where it was paused, other wise it 
 * will start the playback from the beginning. if the current media 
 * item is not yet initialized or is not ready to play it will invoke
 * prepareToPlay first.
 */
- (void) play;

/** @name Managing Playback */
/**
 * Pauses the playback of the current media item.
 *
 * If the playback was already paused or stopped, this method has no effect.
 * In order to resume the playback of the current media item, call the play 
 * method.
 */
- (void) pause;

/** @name Managing Playback */
/**
 * Stops the playback of the current media item.
 *
 * If the media playback was already stopped, this method has no effect.
 * The stop method releases any hardware resources which were associated 
 * with the current media and reset the currentTime or currentDate
 * properties, so a call to play will resume the playback from the begining.
 */
- (void) stop;

/** @name Managing Playback */
/**
 * Initiates a seek to the specified time.
 *
 * This method will not change the status of the MediaPlayer.
 */
- (void) seekToTime:(CMTime)time;

/**
 * Initiates a seek to the specified time and executes the specified block when the seek operation has
 * either been completed or been interrupted.
 *
 * This method will not change the status of the MediaPlayer.
 * The seek operation is asynchronous. A notification will be dispatched
 * to signal the completion of the seek operation.
 */
- (void) seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end
