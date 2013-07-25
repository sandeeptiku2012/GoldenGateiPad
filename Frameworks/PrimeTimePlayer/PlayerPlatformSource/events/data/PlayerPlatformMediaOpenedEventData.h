//
//  MediaOpenedEventData.h
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

@interface PlayerPlatformMediaOpenedEventData : PlayerPlatformVideoEventData
extern NSString* const KEY_FOR_MEDIA_TYPE;
extern NSString* const KEY_FOR_WIDTH;
extern NSString* const KEY_FOR_HEIGHT;
extern NSString* const KEY_FOR_PLAYBACK_SPEEDS;
extern NSString* const KEY_FOR_AVAILABLE_AUDIO_LANGUAGES;

@property(nonatomic, retain)NSString* mediaType;
@property(nonatomic)NSNumber* width;
@property(nonatomic)NSNumber* height;
@property(nonatomic, retain)NSArray* playbackSpeeds;
@property(nonatomic, retain)NSArray* availableAudioLanguages;

-(NSMutableDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary *)dict;

@end
