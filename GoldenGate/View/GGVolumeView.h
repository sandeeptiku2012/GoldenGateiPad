//
//  GGVolumeView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>


/*!
 @abstract This class provides a customized MPVolumeView with a design that matches
 the rest of the application.
 */
@interface GGVolumeView : MPVolumeView
@property (strong, nonatomic) IBOutlet UILabel *volumeValueLabel;
@property (weak, nonatomic) UISlider *volumeSlider;

@end
