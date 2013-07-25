//
//  PlayerPlatformAdBreakEventData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 1/7/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "PlayerPlatformAdBreakCompleteEventData.h"

@implementation PlayerPlatformAdBreakCompleteEventData
NSString* const KEY_FOR_AD_BREAK = @"adBreakKey";
-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.adBreak forKey:KEY_FOR_AD_BREAK];    
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.adBreak = [dict objectForKey:KEY_FOR_AD_BREAK];
}
@end
