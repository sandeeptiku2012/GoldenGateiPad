//
//  MediaProgressEventData.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformMediaProgressEventData.h"
@interface PlayerPlatformMediaProgressEventData()
{
    NSNumber* _position;
    NSNumber* _startPosition;
    NSNumber* _endPosition;
    NSNumber* _playbackSpeed;
}
@end

@implementation PlayerPlatformMediaProgressEventData

@synthesize position = _position;
@synthesize startPosition = _startPosition;
@synthesize endPosition = _endPosition;
@synthesize playbackSpeed = _playbackSpeed;


NSString* const KEY_FOR_POSITION = @"position";
NSString* const KEY_FOR_START_POSITION = @"startPosition";
NSString* const KEY_FOR_END_POSITION = @"endPosition";
NSString* const KEY_FOR_PLAYBACK_SPEED = @"playbackSpeed";

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.position forKey:KEY_FOR_POSITION];
    [dict setValue:self.startPosition forKey:KEY_FOR_START_POSITION];
    [dict setValue:self.endPosition forKey:KEY_FOR_END_POSITION];
    [dict setValue:self.playbackSpeed forKey:KEY_FOR_PLAYBACK_SPEED];
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

-(void)fromDictionary:(NSDictionary*)dict
{
    self.position = [dict objectForKey:KEY_FOR_POSITION];
    self.startPosition = [dict objectForKey:KEY_FOR_START_POSITION];
    self.endPosition = [dict objectForKey:KEY_FOR_END_POSITION];
    self.playbackSpeed = [dict objectForKey:KEY_FOR_PLAYBACK_SPEED];
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}

@end
