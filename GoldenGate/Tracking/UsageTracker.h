//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UsageTracking.h"

@class UsageEventTemplate;


@interface UsageTracker : NSObject <UsageTracking>

- (void)registerUsageTracker:(id<UsageTracking>)tracker withName:(NSString *)name;
- (void)registerEventTemplate:(UsageEventTemplate*)template;


/*!
 @abstract
 This method uses the UsageEventTemplate defined for the given eventId to extract
 values for the "label" and "value" values that are sent to the tracking system.
 */
- (void)trackEvent:(NSInteger)eventId eventData:(id)eventData;
- (void)trackTiming:(NSInteger)eventId eventData:(id)eventData;

@property (assign, readonly, nonatomic) BOOL trackingActive;

@end