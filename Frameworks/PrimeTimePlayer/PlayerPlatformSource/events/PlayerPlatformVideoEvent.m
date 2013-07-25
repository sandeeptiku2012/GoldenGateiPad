//
//  VideoEvent.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "PlayerPlatformVideoEvent.h"

@implementation PlayerPlatformVideoEvent

NSString* const MEDIA_OPENED = @"MediaOpened";
NSString* const MEDIA_FAILED = @"MediaFailed";
NSString* const MEDIA_WARNING = @"MediaWarning";
NSString* const MEDIA_ENDED = @"MediaEnded";
NSString* const MEDIA_PROGRESS = @"MediaProgress";
NSString* const MEDIA_CHANGED = @"MediaChanged";
NSString* const PLAY_STATE_CHANGED = @"PlayStateChanged";
NSString* const BITRATE_CHANGED = @"BitrateChanged";
NSString* const PLAYBACK_SPEED_CHANGED = @"PlaybackSpeedChanged";
NSString* const CAPTIONS_DATA_READY = @"CaptionsDataReady";
NSString* const MISSING_DRM_TOKEN = @"MissingDRMToken";
NSString* const DURATION_CHANGE = @"DurationChanged";
NSString* const PLAYER_READY = @"PlayerReady";
NSString* const DRM_FAILURE = @"DrmFailure";
NSString* const DRM_COMPLETE = @"DrmComplete";
NSString* const OFFLINE_DRM_FAILURE = @"OfflineDrmFailure";
NSString* const OFFLINE_DRM_COMPLETE = @"OfflineDrmComplete";
NSString* const AD_BREAK_COMPLETE = @"AdBreakComplete";
NSString* const AD_BREAK_STARTED = @"AdBreakStarted";
NSString* const AD_PLAY_STARTED = @"AdPlayStarted";
NSString* const AD_PLAY_COMPLETE = @"AdPlayComplete";
NSString* const AD_PLAY_PROGRESS = @"AdPlayProgess";
NSString* const EAS_COMPLETE = @"EasComplete";
NSString* const EAS_FAILURE = @"EasFailure";

@end