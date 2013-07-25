//
//  ModalEntityRelatedViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 17/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//


#import "GGBaseViewController.h"
#import "LoadingView.h"
#import "GridViewController.h"


@class Entity;
@class DisplayEntity;
@class EntityModalViewController;
@class BundleModalViewControllerHelper;
@class ChannelModalViewControllerHelper;


@protocol ModalEntityRelatedViewControllerDelegate <NSObject>

@optional

-(void)backButtonTappedOnRelated;
-(void)cellOnGridTappedOnRelatedContentViewWithEntity : (Entity*)entity;

@end


@interface ModalEntityRelatedViewController : GGBaseViewController<LoadingViewDelegate, GridViewControllerDelegate>

@property (weak, nonatomic) UINavigationController *navController;
@property (weak, nonatomic) id<ModalEntityRelatedViewControllerDelegate> delegate;
@property (weak, nonatomic) DisplayEntity *dispEntity;


@property (weak, nonatomic) EntityModalViewController *entityModalViewController;
@property (weak, nonatomic) BundleModalViewControllerHelper *bundleModalViewControllerHelper;
@property (weak, nonatomic) ChannelModalViewControllerHelper *channelModalViewControllerHelper;


+ (BOOL)canDisplayRelatedViewForEntity:(Entity*)argEntity;

- (id)initWithEntity:(DisplayEntity *)entity;

- (void)fadeInNavBar;

@end
