//
//  EntityModalViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "GGBaseViewController.h"
#import "LoadingView.h"
#import "DisplayEntity.h"
#import "ElementsView.h"
#import "EntityModalViewControllerHelper.h"
#import "ModalEntityRelatedViewController.h"


@class Entity;
@class LikeBarButton;

/*!
 @abstract
 This view controller overlays a "fake" modal view onto the app.
 The view presents the content of a channel in a detailed manner.
 */

@interface EntityModalViewController : GGBaseViewController<UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate, ElementsViewDelegate, EntityModalViewControllerHelperDelegate, ModalEntityRelatedViewControllerDelegate>

@property (weak, nonatomic) Entity *dispEntity;
@property (weak, nonatomic) UINavigationController *navController; // Used for presenting videos
@property (strong, nonatomic) IBOutlet LikeBarButton *likeButton;


/*!
 @abstract
 @param view The view to animate the frame of the presented modal view from. use nil if you don't want an animation.
 @param channel The channel to present information for.
 @param navController The UINavigationController that the VideoPlaybackViewController will be presented from if the user selects a video.
 */
+ (void)showFromView:(UIView *)view withEntity:(Entity *)entity navController:(UINavigationController *)navController;


@end
