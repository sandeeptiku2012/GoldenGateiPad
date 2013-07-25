//
//  Created by Andreas Petrov on 11/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import "GATrackerProxy.h"
#import "GAITracker.h"
#import "GAI.h"


@implementation GATrackerProxy
{

}
- (id)initWithGoogleTracker:(id <GAITracker>)googleTracker
{
    if ((self = [super init]))
    {
        self.googleTracker = googleTracker;
    }

    return self;
}

+ (GATrackerProxy *)createWithGoogleTracker:(id <GAITracker>)googleTracker
{
    return [[GATrackerProxy alloc] initWithGoogleTracker:googleTracker];
}

- (BOOL)trackView:(NSString *)viewName
{
    
    return [self.googleTracker sendView:viewName];
}

+ (GATrackerProxy *)createWithUACode:(NSString *)uaCode makeDefault:(BOOL)makeDefault
{
    id<GAITracker> googleTracker = [[GAI sharedInstance] trackerWithTrackingId:uaCode];

    if (makeDefault)
    {
        [GAI sharedInstance].defaultTracker = googleTracker;
        
#if DEBUG
        [GAI sharedInstance].debug = YES;
#endif
    }

    return [[GATrackerProxy alloc] initWithGoogleTracker:googleTracker];
}

- (BOOL)trackEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label withValue:(NSNumber *)value
{
    return [self.googleTracker trackEventWithCategory:category withAction:action withLabel:label withValue:value];
}

- (BOOL)trackTimingWithCategory:(NSString *)category withValue:(NSTimeInterval)time withName:(NSString *)name withLabel:(NSString *)label
{
    return [self.googleTracker trackTimingWithCategory:category withValue:time withName:name withLabel:label];
}

- (void)startSession
{
    self.googleTracker.sessionStart = YES;
}

- (void)endSession
{
    [[GAI sharedInstance]dispatch];
}

@end