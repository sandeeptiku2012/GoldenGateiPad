//
//  MediaChangedEventData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 10/30/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformMediaChangedEventData.h"

@implementation PlayerPlatformMediaChangedEventData
NSString* const KEY_FOR_CURRENT_URL = @"currentUrl";
-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.currentUrl forKey:KEY_FOR_CURRENT_URL];
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.currentUrl = [dict objectForKey:KEY_FOR_CURRENT_URL];
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}

@end
