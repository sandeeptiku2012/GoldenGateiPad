//
//  PlayStateChangedEventData.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/12/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import <Foundation/Foundation.h>
#import "PlayerPlatformVideoEventData.h"

@interface PlayerPlatformMediaPlayStateChangedEventData : PlayerPlatformVideoEventData
{
    NSString* _playState;
}

extern NSString* const KEY_FOR_PLAY_STATE;


@property(nonatomic) NSString* playState;

-(NSMutableDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary*)dict;


@end
