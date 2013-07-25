//
//  ModalRelatedContentViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBaseViewController.h"

#import "LoadingView.h"
#import "GridViewController.h"

@class Channel;
@class ChannelModalViewController;

@interface ModalRelatedContentViewController : GGBaseViewController <LoadingViewDelegate, GridViewControllerDelegate>

@property (assign, nonatomic) SEL dismissSelector;
@property (weak, nonatomic) id dismissTarget;
@property (weak, nonatomic) UINavigationController *navController;

@property (weak, nonatomic) Channel *channel;

/*!
 @abstract
 A pointer to the ChannelModalViewController that presented this view controller.
 @note 
 It's absolutely not elegant with this circular dependency, but a rewrite is outside
 the time-scope of the current delivery.
 */
@property (weak, nonatomic) ChannelModalViewController *channelModalViewController;

- (id)initWithChannel:(Channel *)channel;

- (void)fadeInNavBar;

@end
