//
//  BitrateChangedEventData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 11/27/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformBitrateChangedEventData.h"
#import "PlayerPlatformMediaOpenedEventData.h"
@implementation PlayerPlatformBitrateChangedEventData
NSString* const KEY_FOR_BITRATE = @"bitrate";

-(void)fromDictionary:(NSDictionary*)dict
{
    self.bitrate = [dict objectForKey:KEY_FOR_BITRATE];
    self.height = [dict objectForKey:KEY_FOR_HEIGHT];
    self.width = [dict objectForKey:KEY_FOR_WIDTH];
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.bitrate forKey:KEY_FOR_BITRATE];
    [dict setValue:self.height forKey:KEY_FOR_HEIGHT];
    [dict setValue:self.width forKey:KEY_FOR_WIDTH];
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

@end
