//
//  MediaFailedEventData.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformVideoEventData.h"

@interface PlayerPlatformMediaFailedEventData : PlayerPlatformVideoEventData

-(NSMutableDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary *)dict;

@end
