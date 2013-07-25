//
//  UsageTrackerProxy.h
//  GoldenGate
//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsageTracking.h"

@interface UsageTrackerProxy : NSObject <UsageTracking>




@property (strong, nonatomic) id trackerSubject;

- (id)initWithTrackerSubject:(id)trackerSubject;


@end
