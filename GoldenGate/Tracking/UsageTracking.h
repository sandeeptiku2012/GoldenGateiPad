//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


@protocol UsageTracking <NSObject>

- (BOOL)trackView:(NSString*)viewName;

- (BOOL)trackEventWithCategory:(NSString *)category
                    withAction:(NSString *)action
                     withLabel:(NSString *)label
                     withValue:(NSNumber *)value;

- (BOOL)trackTimingWithCategory:(NSString *)category
                      withValue:(NSTimeInterval)time
                       withName:(NSString *)name
                      withLabel:(NSString *)label;


- (void)startSession;
- (void)endSession;

@end