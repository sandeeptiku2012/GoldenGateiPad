//
//  VideoPlaybackViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "GGBaseViewController.h"
#import "LoadingView.h"
#import "TimedUserInterfaceVisibilityController.h"

@class Video;
@class Channel;

@interface VideoPlaybackViewController : GGBaseViewController <LoadingViewDelegate, TimedUserInterfaceVisibilityControllerDelegate>

+ (void)presentVideo:(Video*)video
         fromChannel:(Channel*)channel
withNavigationController:(UINavigationController*)navigationController;

@property (strong, nonatomic) Video *currentVideo;
@property (strong, nonatomic) Channel *currentChannel;

@end
