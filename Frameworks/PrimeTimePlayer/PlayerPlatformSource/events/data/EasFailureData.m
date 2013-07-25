//
//  EasFailureData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 1/31/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "EasFailureData.h"
#import "EasCompletedData.h"
#import "PlayerPlatformMediaFailedEventData.h"

@implementation EasFailureData
-(NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.identifier forKey:KEY_FOR_IDENTIFIER];
    [dict setValue:self.errorCode forKey:KEY_FOR_CODE];
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.identifier = [dict valueForKey:KEY_FOR_IDENTIFIER];
    self.errorCode = [dict valueForKey:KEY_FOR_CODE];
}
@end
