//
//  VideoEvent.h
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

@interface PlayerPlatformVideoEvent : NSObject

extern NSString* const MEDIA_OPENED;
extern NSString* const MEDIA_FAILED;
extern NSString* const MEDIA_WARNING;
extern NSString* const MEDIA_ENDED;
extern NSString* const MEDIA_PROGRESS;
extern NSString* const MEDIA_CHANGED;
extern NSString* const PLAY_STATE_CHANGED;
extern NSString* const BITRATE_CHANGED;
extern NSString* const PLAYBACK_SPEED_CHANGED;
extern NSString* const CAPTIONS_DATA_READY;
extern NSString* const MISSING_DRM_TOKEN;
extern NSString* const DURATION_CHANGE;
extern NSString* const PLAYER_READY;
extern NSString* const DRM_FAILURE;
extern NSString* const DRM_COMPLETE;
extern NSString* const OFFLINE_DRM_FAILURE;
extern NSString* const OFFLINE_DRM_COMPLETE;
extern NSString* const AD_BREAK_COMPLETE;
extern NSString* const AD_BREAK_STARTED;
extern NSString* const AD_PLAY_STARTED;
extern NSString* const AD_PLAY_COMPLETE;
extern NSString* const AD_PLAY_PROGRESS;
extern NSString* const EAS_COMPLETE;
extern NSString* const EAS_FAILURE;

@end

