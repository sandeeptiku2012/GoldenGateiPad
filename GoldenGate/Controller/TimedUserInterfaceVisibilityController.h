//
//  TimedUserInterfaceVisibilityController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 12/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimedUserInterfaceVisibilityController;

@protocol TimedUserInterfaceVisibilityControllerDelegate <NSObject>

- (void)timedUserInterfaceVisibilityController:(TimedUserInterfaceVisibilityController*)visibilityController didSetUIVisible:(BOOL)visible;

@end

@interface TimedUserInterfaceVisibilityController : NSObject <UIGestureRecognizerDelegate>

- (id)initWithInactivityTimeoutInterval:(NSTimeInterval)timeInterval;

- (void)restartInactivityTimer;
- (void)startTrackingInactivity;
- (void)stopTrackingInactivity;

@property (weak, nonatomic) id<TimedUserInterfaceVisibilityControllerDelegate> delegate;

@end
