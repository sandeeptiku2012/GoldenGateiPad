//
//  TimedUserInterfaceVisibilityController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 12/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TimedUserInterfaceVisibilityController.h"
#import "Stopwatch.h"

@interface TimedUserInterfaceVisibilityController()

@property (strong, nonatomic) NSTimer *playbackControlsHidingTimer;
@property (strong, nonatomic) Stopwatch *interactionStopwatch;
@property (assign, nonatomic) NSTimeInterval inactivityInterval;

@property (strong, nonatomic) UITapGestureRecognizer *fullscreenTapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *fullscreenPanGestureRecognizer;

@end

@implementation TimedUserInterfaceVisibilityController

- (void)restartInactivityTimer
{
    [self.interactionStopwatch start];
}

- (id)initWithInactivityTimeoutInterval:(NSTimeInterval)timeInterval
{
    if ((self = [super init]))
    {
        self.inactivityInterval = timeInterval;
        self.interactionStopwatch = [Stopwatch new];
    }

    return self;
}

- (void)startTrackingInactivity
{
    [self addFullscreenGestureRecognizers];
    [self.interactionStopwatch start];
    [self startPlaybackControlsHidingTimerWithTimeInterval:self.inactivityInterval];
}

- (void)stopTrackingInactivity
{
    [self.playbackControlsHidingTimer invalidate];
    self.playbackControlsHidingTimer = nil;
    [self removeFullscreenGestureRecognizers];
}

- (void)startPlaybackControlsHidingTimerWithTimeInterval:(NSTimeInterval)interval
{
    [self.playbackControlsHidingTimer invalidate];
    self.playbackControlsHidingTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                                       target:self
                                                                     selector:@selector(playbackControlsHidingTimerDidFire)
                                                                     userInfo:nil
                                                                      repeats:NO];
}

- (void)playbackControlsHidingTimerDidFire
{
    NSTimeInterval runtime = [self.interactionStopwatch runtime];
    BOOL shouldHideUI = runtime > self.inactivityInterval;
    if (shouldHideUI)
    {
        if ([self.delegate respondsToSelector:@selector(timedUserInterfaceVisibilityController:didSetUIVisible:)])
        {
            [self.delegate timedUserInterfaceVisibilityController:self didSetUIVisible:NO];
        }

        [self startTrackingInactivity];
    }
    else
    {
        NSTimeInterval leftoverTimeUntilFadeout = self.inactivityInterval - self.interactionStopwatch.runtime;
        [self startPlaybackControlsHidingTimerWithTimeInterval:leftoverTimeUntilFadeout];
    }
}


- (UITapGestureRecognizer*)fullscreenTapGestureRecognizer
{
    if (_fullscreenTapGestureRecognizer == nil)
    {
        _fullscreenTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(anyTapDetected)];
        _fullscreenTapGestureRecognizer.cancelsTouchesInView = NO;
        _fullscreenTapGestureRecognizer.delegate = self;
    }

    return _fullscreenTapGestureRecognizer;
}


- (UIPanGestureRecognizer*)fullscreenPanGestureRecognizer
{
    if (_fullscreenPanGestureRecognizer == nil)
    {
        _fullscreenPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(anyTapDetected)];
        _fullscreenPanGestureRecognizer.cancelsTouchesInView = NO;
        _fullscreenPanGestureRecognizer.delegate = self;
    }

    return _fullscreenPanGestureRecognizer;
}

- (UIView*)overlayWindow
{
    return [[[[UIApplication sharedApplication]keyWindow]subviews]objectAtIndex:0];
}

- (void)removeFullscreenGestureRecognizers
{
    [self.overlayWindow removeGestureRecognizer:self.fullscreenPanGestureRecognizer];
    [self.overlayWindow removeGestureRecognizer:self.fullscreenTapGestureRecognizer];
}

- (void)addFullscreenGestureRecognizers
{
    // By adding these gesture recognizers any touch in the entire view will be detected.
    // The purpose being to reset the interaction stopwatch so that the ui controllers don't fade out while
    // the user is using the UI.
    [self.overlayWindow addGestureRecognizer:self.fullscreenPanGestureRecognizer];
    [self.overlayWindow addGestureRecognizer:self.fullscreenTapGestureRecognizer];
}

- (void)anyTapDetected
{
    [self restartInactivityTimer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
