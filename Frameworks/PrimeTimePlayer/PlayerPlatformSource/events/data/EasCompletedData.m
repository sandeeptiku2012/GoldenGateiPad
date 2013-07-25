//
//  EasCompletedData.m
// PlayerPlatform
//
//  Created by Cory Zachman on 1/31/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "EasCompletedData.h"

@implementation EasCompletedData
NSString* const KEY_FOR_IDENTIFIER = @"identifier";
-(NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.identifier forKey:KEY_FOR_IDENTIFIER];
    return dict;
}

-(void)fromDictionary:(NSDictionary *)dict
{
    self.identifier = [dict valueForKey:KEY_FOR_IDENTIFIER];
}

@end
