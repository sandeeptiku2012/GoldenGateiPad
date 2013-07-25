//
//  PlayStateChangedEventData.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/12/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformMediaPlayStateChangedEventData.h"

@implementation PlayerPlatformMediaPlayStateChangedEventData

@synthesize playState = _playState;

NSString* const KEY_FOR_PLAY_STATE = @"playState";

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.playState forKey:KEY_FOR_PLAY_STATE];
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.playState = [dict objectForKey:KEY_FOR_PLAY_STATE];
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}


@end
