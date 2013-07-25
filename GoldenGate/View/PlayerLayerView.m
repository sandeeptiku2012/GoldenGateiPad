//
//  PlayerLayerView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 08/30/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import "PlayerLayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "PTMediaPlayerView.h"

@implementation PlayerLayerView



// Setter for Viper (Prime Time) player
- (void)setPtPlayer:(PlayerPlatformAPI *)player
{
    [player.getView setFrame:self.bounds];
    
    // checks if the player is already inserted as subview
    if (self.ptPlayer.getView != player.getView)
    {
        [self.ptPlayer.getView removeFromSuperview];
        
        // Viper (Prime Time) player inserted to player layer view at the bottom most level
        [self insertSubview:player.getView atIndex:0];
        _ptPlayer = player;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews)
    {
        [subview setNeedsLayout];
        [subview layoutIfNeeded];
    }
}

@end
