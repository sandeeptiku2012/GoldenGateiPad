//
//  Created by Andreas Petrov on 11/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UsageTracking.h"

@protocol GAITracker;


@interface GATrackerProxy : NSObject <UsageTracking>



@property id<GAITracker> googleTracker;

- (id)initWithGoogleTracker:(id <GAITracker>)googleTracker;

+ (GATrackerProxy *)createWithGoogleTracker:(id <GAITracker>)googleTracker;

+ (GATrackerProxy *)createWithUACode:(NSString *)uaCode makeDefault:(BOOL)makeDefault;

@end