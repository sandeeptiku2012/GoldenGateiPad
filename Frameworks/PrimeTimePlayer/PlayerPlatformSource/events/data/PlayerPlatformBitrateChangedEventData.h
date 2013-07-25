//
//  BitrateChangedEventData.h
// PlayerPlatform
//
//  Created by Cory Zachman on 11/27/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformVideoEventData.h"

@interface PlayerPlatformBitrateChangedEventData : PlayerPlatformVideoEventData
extern NSString* const KEY_FOR_BITRATE;
@property NSNumber* bitrate;
@property NSNumber* height;
@property NSNumber* width;


@end
