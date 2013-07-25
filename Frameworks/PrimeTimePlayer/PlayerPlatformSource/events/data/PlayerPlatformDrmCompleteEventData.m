//
//  PlayerPlatformDrmCompleteEventData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 12/28/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PlayerPlatformDrmCompleteEventData.h"

@implementation PlayerPlatformDrmCompleteEventData
NSString* const KEY_FOR_ASSET_URL = @"assetUrl";
NSString* const KEY_FOR_START_DATE= @"drmStartDate";
NSString* const KEY_FOR_END_DATE = @"drmEndDate";
NSString* const KEY_FOR_LICENSE = @"keyForLicense";

-(NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.assetUrl forKey:KEY_FOR_ASSET_URL];
    [dict setValue:self.startDate forKey:KEY_FOR_START_DATE];
    [dict setValue:self.endDate forKey:KEY_FOR_END_DATE];
    [dict setValue:self.license forKey:KEY_FOR_LICENSE];
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.assetUrl = [dict valueForKey:KEY_FOR_ASSET_URL];
    self.startDate = [dict valueForKey:KEY_FOR_START_DATE];
    self.endDate = [dict valueForKey:KEY_FOR_END_DATE];
    self.license = [dict valueForKey:KEY_FOR_LICENSE];
}
@end
