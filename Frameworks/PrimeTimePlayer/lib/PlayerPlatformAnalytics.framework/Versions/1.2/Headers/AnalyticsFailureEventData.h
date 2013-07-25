//
//  AnalyticsFailureEventData.h
//  PlayerPlatformIOSAnalytics
//
//  Created by Cory Zachman on 2/19/13.
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

@interface AnalyticsFailureEventData : NSObject
extern NSString* const KEY_FOR_ANALYTICS_DESC;
extern NSString* const KEY_FOR_ANALYTICS_ERROR;
@property NSString *description;
@property NSNumber *errorCode;

-(NSDictionary*)toDictionary;
-(void)fromDictionary:(NSDictionary*)dictionary;
@end
