//
//  UsageTrackerProxy.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "UsageTrackerProxy.h"
#import "GAITracker.h"

@implementation UsageTrackerProxy

- (id)initWithTrackerSubject:(id)trackerSubject
{
    if ((self = [super init]))
    {
        self.trackerSubject = trackerSubject;
    }

    return self;
}

- (BOOL)trackView:(NSString *)viewName
{
    BOOL success = YES;
    if ([self.trackerSubject respondsToSelector:@selector(trackView:)])
    {
        success = [self.trackerSubject trackView:viewName];
    }

    return success;
}

- (BOOL)trackEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label withValue:(NSNumber *)value
{
    BOOL success = YES;
    if ([self.trackerSubject respondsToSelector:@selector(trackEventWithCategory:withAction:withLabel:withValue:)])
    {
        success = [self.trackerSubject trackEventWithCategory:category withAction:action withLabel:label withValue:value];
    }

    return success;
}

- (void)startSession
{
    if ([self.trackerSubject respondsToSelector:@selector(startSession)])
    {
        [self.trackerSubject startSession];
    }
}

@end
