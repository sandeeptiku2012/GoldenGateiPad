//
//  PlayerPlatformDrmCompleteEventData.h
// PlayerPlatform
//
//  Created by Cory Zachman on 12/28/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformVideoEventData.h"
#import <drmNativeInterface/DRMInterface.h>
@interface PlayerPlatformDrmCompleteEventData : PlayerPlatformVideoEventData
//NSLog(@"DRM License Acquired - Start Date: %@, End Date: %@, Playback Start Date: %@, Playback End Date: %@", license.getLicenseStartDate, license.getLicenseEndDate,license.getPlaybackTimeWindow.getPlaybackStartDate,license.getPlaybackTimeWindow.getPlaybackEndDate);
@property NSString *assetUrl;
@property NSDate *startDate;
@property NSDate *endDate;
@property DRMLicense *license;
extern NSString* const KEY_FOR_ASSET_URL;
extern NSString* const KEY_FOR_START_DATE;
extern NSString* const KEY_FOR_END_DATE;
extern NSString* const KEY_FOR_LICENSE;
@end
