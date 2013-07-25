//
//  Stopwatch.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/03/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "Stopwatch.h"

@interface Stopwatch()

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *stopTime;

@end

@implementation Stopwatch

- (void)start
{
    self.startTime = [NSDate date];
    self.stopTime = nil;
}

- (void)stop
{
    self.stopTime = [NSDate date];
}

- (NSTimeInterval)runtime
{
    return [[NSDate date] timeIntervalSinceDate:self.startTime != nil ? self.startTime : [NSDate date]];
}

@end
