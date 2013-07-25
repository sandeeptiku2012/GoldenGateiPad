//
//  EntityVideoPlayBackViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 14/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "GGBaseViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import "GGBaseViewController.h"
#import "LoadingView.h"
#import "TimedUserInterfaceVisibilityController.h"


@class Video;
@class DisplayEntity;

@interface EntityVideoPlayBackViewController : GGBaseViewController<LoadingViewDelegate, TimedUserInterfaceVisibilityControllerDelegate>

+ (void)presentVideo:(Video*)video
         fromEntity:(DisplayEntity*)dispEntity
withNavigationController:(UINavigationController*)navigationController;

@property (strong, nonatomic) Video *currentVideo;
@property (strong, nonatomic) DisplayEntity *currentEntity;

@end
