//
//  MediaFailedEventData.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformMediaFailedEventData.h"

@implementation PlayerPlatformMediaFailedEventData

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}

@end
