//
//  PlayerLayerView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 08/30/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//

#import <UIKit/UIKit.h>

// Adding Viper (Prime Time) player
#import "PlayerPlatform.h"



@class AVPlayer;

/*!
 @abstract This class delivers an UIView that has an AVPlayerLayer as main layer.
 This layer type is required to show video.
 */
@interface PlayerLayerView : UIView {

}

// Viper (Prime Time) player for the view
@property (strong, nonatomic) PlayerPlatformAPI *ptPlayer;

@end

