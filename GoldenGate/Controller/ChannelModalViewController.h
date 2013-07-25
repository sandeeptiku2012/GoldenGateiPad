//
//  ChannelModalViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGBaseViewController.h"
#import "LoadingView.h"

@class Channel;
@class LikeBarButton;

/*!
 @abstract
 This view controller overlays a "fake" modal view onto the app.
 The view presents the content of a channel in a detailed manner.
*/
@interface ChannelModalViewController : GGBaseViewController <UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate>

@property (weak, nonatomic) Channel *channel;
@property (weak, nonatomic) UINavigationController *navController; // Used for presenting videos
@property (strong, nonatomic) IBOutlet LikeBarButton *likeButton;


/*!
 @abstract
 @param view The view to animate the frame of the presented modal view from. use nil if you don't want an animation.
 @param channel The channel to present information for.
 @param navController The UINavigationController that the VideoPlaybackViewController will be presented from if the user selects a video.
 */
+ (void)showFromView:(UIView *)view withChannel:(Channel *)channel navController:(UINavigationController *)navController;

@end
