//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "TFTracker.h"
#import "TestFlight.h"


@implementation TFTracker
{

}

+ (TFTracker*)createTrackerWithTeamToken:(NSString *)teamToken
{
    return [[TFTracker alloc] initWithTeamToken:teamToken];
}

- (id)initWithTeamToken:(NSString *)teamToken
{
    if ((self = [super init]))
    {
        _teamToken = teamToken;
    }

    return self;
}

- (BOOL)trackView:(NSString *)viewName
{
    NSString *checkPointName = [NSString stringWithFormat:@"View Passed:%@",viewName];
    [TestFlight passCheckpoint:checkPointName];
    return YES;
}

- (BOOL)trackEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label withValue:(NSNumber *)value
{
    return YES;
}

- (BOOL)trackTimingWithCategory:(NSString *)category withValue:(NSTimeInterval)time1 withName:(NSString *)name withLabel:(NSString *)label
{
    return YES;
}

- (void)startSession
{
    if (self.teamToken) {
         [TestFlight takeOff:self.teamToken];
    }
   
}

- (void)endSession
{
    // DO NOTHING
}


@end