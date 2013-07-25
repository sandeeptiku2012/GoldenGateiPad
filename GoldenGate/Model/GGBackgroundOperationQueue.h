//
//  GGBackgroundOperationQueue.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/16/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract
 Use this shared operation queue to do background processing.
 Should mostly be used for operations that should finish regardless of view controller state.
 If you want an operation to cancel as soon as you dismiss the current viewController please use
 GGBaseViewController viewControllerOperationQueue
 */
@interface GGBackgroundOperationQueue : NSObject

+ (NSOperationQueue *)sharedInstance;


@end
