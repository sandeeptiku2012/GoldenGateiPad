//
//  KITAsserts.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use to check that the current code isn't running on the main queue.
// Useful to sprinkle about in slow code that should be running in a background queue
#define KITAssertIsNotOnMainQueue() \
NSAssert([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue],@"")

#define KITAssertIsKindOfClass(object, class) \
NSAssert(object == nil || [object isKindOfClass: class],@"")