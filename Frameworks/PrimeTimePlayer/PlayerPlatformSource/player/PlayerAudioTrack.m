//
//  PlayerAudioTrack.m
//  PlayerPlatform
//
//  Created by Cory Zachman on 4/1/13.
//  Copyright (c) 2013 Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation. All rights reserved.
//

#import "PlayerAudioTrack.h"
#import "PTMediaSelectionOption.h"
@interface PlayerAudioTrack()
{
    PTMediaSelectionOption *_ptMediaSelectionOption;
}
@end

@implementation PlayerAudioTrack
-(PlayerAudioTrack*)initWithPTMediaSelectionOption:(PTMediaSelectionOption*)mediaSelectionOption
{
    self = [super init];
    if(self)
    {
        _ptMediaSelectionOption = mediaSelectionOption;
    }
    return self;
}
-(PTMediaSelectionOption*)getMediaSelectionOption
{
    return _ptMediaSelectionOption;
}
-(NSString*)getLanguage
{
    if(_ptMediaSelectionOption != nil)
    {
        return _ptMediaSelectionOption.locale.localeIdentifier;
    }
    else
    {
        return nil;
    }
}
@end
