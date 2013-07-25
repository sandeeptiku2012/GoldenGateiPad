//
//  MediaOpenedEventData.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformMediaOpenedEventData.h"
@interface PlayerPlatformMediaOpenedEventData ()
{
    NSString* _mediaType;
    NSNumber* _width;
    NSNumber* _height;
    NSArray* _playbackSpeeds;
    NSArray* _availableAudioLanguages;
}
@end

@implementation PlayerPlatformMediaOpenedEventData

@synthesize mediaType = _mediaType;
@synthesize width = _width;
@synthesize height = _height;
@synthesize playbackSpeeds = _playbackSpeeds;
@synthesize availableAudioLanguages = _availableAudioLanguages;

NSString* const KEY_FOR_MEDIA_TYPE = @"mediaType";
NSString* const KEY_FOR_WIDTH = @"width";
NSString* const KEY_FOR_HEIGHT = @"height";
NSString* const KEY_FOR_PLAYBACK_SPEEDS = @"playbackSpeeds" ;
NSString* const KEY_FOR_AVAILABLE_AUDIO_LANGUAGES = @"availableAudioLanguages" ;


-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.mediaType forKey:KEY_FOR_MEDIA_TYPE];
    [dict setValue:self.width forKey:KEY_FOR_WIDTH];
    [dict setValue:self.height forKey:KEY_FOR_HEIGHT];
    [dict setValue:self.playbackSpeeds forKey:KEY_FOR_PLAYBACK_SPEEDS];
    [dict setValue:self.availableAudioLanguages forKey:KEY_FOR_AVAILABLE_AUDIO_LANGUAGES];
    [dict setValue:self.code forKey:KEY_FOR_CODE];
    [dict setValue:self.description forKey:KEY_FOR_DESCREPTION];
    
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.mediaType = [dict objectForKey:KEY_FOR_MEDIA_TYPE];
    self.width = [dict objectForKey:KEY_FOR_WIDTH];
    self.height = [dict objectForKey:KEY_FOR_HEIGHT];
    self.playbackSpeeds = [dict objectForKey:KEY_FOR_PLAYBACK_SPEEDS];
    self.availableAudioLanguages = [dict objectForKey:KEY_FOR_AVAILABLE_AUDIO_LANGUAGES];
    self.code = [dict objectForKey:KEY_FOR_CODE];
    self.description = [dict objectForKey:KEY_FOR_DESCREPTION];
}

@end
