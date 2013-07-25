//
//  PlayerPlatformAdPlayCompleteEventData.h
// PlayerPlatform
//
//  Created by Cory Zachman on 1/7/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "PlayerPlatformVideoEventData.h"
#import "VideoAd.h"
@interface PlayerPlatformAdPlayCompleteEventData : PlayerPlatformVideoEventData
extern NSString* const KEY_FOR_AD;
@property VideoAd *ad;
@end
