//
//  DisplayEntity.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "DisplayEntity.h"

@implementation DisplayEntity

+(DisplayEntityType)getDisplayEntityFromString:(NSString*)strEntity
{
    int iRet = DisplayEntityAll;

    if (nil!=strEntity) {
        if ([strEntity isEqualToString:LEVEL_CHANNEL]) {
            iRet = DisplayEntityChannels;
        }else if([strEntity isEqualToString:LEVEL_SHOW])
        {
            iRet = DisplayEntityShows;
        }
    }
    
    return iRet;
}

- (id)initWithId:(int)identifier
{
    if (self = [super init])
    {
        self.identifier = identifier;
    }
    return self;
}

//need to override
- (NSString *)logoURLStringForSize:(CGSize)size
{
    return nil;
}

@end
