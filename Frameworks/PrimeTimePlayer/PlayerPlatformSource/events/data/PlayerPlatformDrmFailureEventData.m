//
//  PlayerPlatformDrmFailureEventData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 12/27/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformDrmFailureEventData.h"

@implementation PlayerPlatformDrmFailureEventData
NSString* const KEY_FOR_MAJOR = @"major";
NSString* const KEY_FOR_MINOR = @"minor";
NSString* const KEY_FOR_ERROR = @"error";

-(NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.major forKey:KEY_FOR_MAJOR];
    [dict setValue:self.minor forKey:KEY_FOR_MINOR];
    [dict setValue:self.error forKey:KEY_FOR_ERROR];
    return dict;

}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.major = [dict valueForKey:KEY_FOR_MAJOR];
    self.minor = [dict valueForKey:KEY_FOR_MINOR];
    self.error = [dict valueForKey:KEY_FOR_ERROR];
}

@end
