//
//  PlayerPlatformConfigFailedEvent.h
//  PlayerPlatformUtil
//
//  Created by Cory Zachman on 3/12/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerPlatformConfigFailedEvent : NSObject

@property (nonatomic)NSNumber* majorCode;
@property (nonatomic)NSNumber* minorCode;
@property (nonatomic)NSString* messageId;
@property (nonatomic)NSString* majorDesc;
@property (nonatomic)NSString* minorDesc;
@property (nonatomic)NSString* type;

extern NSString* const CONFIG_MAJOR_CODE;
extern NSString* const CONFIG_MAJOR_DESC;
extern NSString* const CONFIG_MESSAGE_ID;
extern NSString* const CONFIG_MINOR_CODE;
extern NSString* const CONFIG_MINOR_DESC;

-(NSMutableDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary*)dict;

@end
