//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UsageTracking.h"

/*!
 @abstract
 This class allows the TestFlight framework to be used with the UsageTracker class.
 Currently it only implements the page-view tracking since this seems to be what the TF SDK supports for now.
 */

@interface TFTracker : NSObject <UsageTracking>

@property (copy, readonly, nonatomic) NSString *teamToken;

- (id)initWithTeamToken:(NSString *)teamToken;
+ (TFTracker*)createTrackerWithTeamToken:(NSString *)teamToken;

@end