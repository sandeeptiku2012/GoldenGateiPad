//
//  Stopwatch.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/03/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stopwatch : NSObject

- (void)start;
- (void)stop;

@property (nonatomic, readonly) NSTimeInterval runtime;

@end
