//
//  PlayerClosedCaptionTrack.m
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

#import "PlayerClosedCaptionTrack.h"
#import "PTMediaSelectionOption.h"
@interface PlayerClosedCaptionTrack()
{
    PTMediaSelectionOption *_closedCaptionTrack;
}
@end
@implementation PlayerClosedCaptionTrack
-(id)initWithPTMediaSelectionOption:(id)mediaSelectionOption
{
    self = [super init];
    if(self)
    {
        _closedCaptionTrack = mediaSelectionOption;
    }
    return self;
}

-(PTMediaSelectionOption*)getMediaSelectionOption
{
    return _closedCaptionTrack;
}

-(NSString*)getLanguage
{
    if(_closedCaptionTrack != nil)
    {
        return _closedCaptionTrack.locale.localeIdentifier;
    }
    else
    {
        return nil;
    }
}

-(NSString*)getOptionId
{
    return _closedCaptionTrack.optionId;
}

-(NSString*)getTitle
{
    return _closedCaptionTrack.title;
}

-(BOOL)isSelected
{
    return _closedCaptionTrack.selected;
}

-(BOOL)isDefault
{
    return _closedCaptionTrack.isDefault;
}

@end
