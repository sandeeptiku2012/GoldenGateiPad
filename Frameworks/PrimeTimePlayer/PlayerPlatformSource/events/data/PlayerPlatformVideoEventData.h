//
//  VideoEventData.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import <Foundation/Foundation.h>

@interface PlayerPlatformVideoEventData : NSObject
extern NSString* const KEY_FOR_CODE;
extern NSString* const KEY_FOR_DESCREPTION;


@property(nonatomic, retain)NSString* description;
@property(nonatomic)NSString* code;

-(NSMutableDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary*)dict;

@end
