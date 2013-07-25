//
//  AnalyticsProvider.h
//  PlayerPlatformIOSAnalytics
//
//  Created by Cory Zachman on 10/29/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//

#import <Foundation/Foundation.h>
#import "XuaPlayerParams.h"
#import "AbstractXMessageBuilder.h"
#import "AnalyticsFailureEventData.h"
#import <PlayerPlatformUtil/ConfigurationManager.h>

@interface AnalyticsProvider : NSObject
extern NSString* const ANALYTICS_FAILURE;
+(id)sharedInstance;
-(void)configureAnalytics:(XuaPlayerParams*) params withUrl:(NSString*) url;
-(void)buildMessage:(AbstractXMessageBuilder*) message;
-(void)buildMessage:(AbstractXMessageBuilder*) message withDelegate:(id)delegate;
-(void)forceSendMessage;
-(void)forceSendMessage:(id)delegate;
-(void)initializeTimer;
-(void)invalidateTimer;
@end
