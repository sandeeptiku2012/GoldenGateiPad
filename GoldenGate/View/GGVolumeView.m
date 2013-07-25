//
//  GGVolumeView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <objc/runtime.h>
#import "GGVolumeView.h"
#import "GGColor.h"
#import "GGVolumeSlider.h"

#define kVolumeIndicatorImageNameBase @"VolumeIndicator%d.png"
#define kVolumeIndicatorImageHorizontalPadding 5
#define kVolumeAirplayButtonHorizontalPadding 20

@interface GGVolumeView()

@property (strong, nonatomic) UIImageView *volumeIndicatorImage;


@property (weak, nonatomic) UIButton *airplayButton;
@property (strong, nonatomic) NSMutableArray *volumeValueList;

@end

@implementation GGVolumeView

-(void) volumeSliderButtonAction
{
     NSLog(@"%f",self.volumeSlider.value);
        NSString *slidervolume=[NSString stringWithFormat:@"%.1f",self.volumeSlider.value];
        if([slidervolume isEqualToString:@"0.5"]){
            [self.volumeSlider setValue:1.0 animated:YES];
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
        }else if([slidervolume isEqualToString:@"1.0"]){
            [self.volumeSlider setValue:0.0 animated:YES];
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
        }else if([slidervolume isEqualToString:@"0.0"]){
            [self.volumeSlider setValue:0.5 animated:YES];
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.5];
        }else{
            [self.volumeSlider setValue:0.0 animated:YES];
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
        }
    self.volumeValueLabel.text = [NSString stringWithFormat:@"%.1f", self.volumeSlider.value];
   
}


- (void)commonInit
{
    [self replaceVolumeSliderMethods];

    for (UIView *view in self.subviews)
    {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"])
        {
            self.volumeSlider = (UISlider *)view;
            // Reset the volume slider images to the default by giving in nil as images.
            // The default image is different from the slider usually used by the slider in MPVolumeView
            [self.volumeSlider setThumbImage: [UIImage imageNamed:@"VolumeSliderKnob.png"] forState: UIControlStateNormal];
            [self.volumeSlider setMinimumTrackImage: nil forState: UIControlStateNormal];
            [self.volumeSlider setMaximumTrackImage: nil forState: UIControlStateNormal];
            
            // Set the beautiful golden track color!
            self.volumeSlider.minimumTrackTintColor = [GGColor lightGoldColor];
            self.volumeSlider.maximumTrackTintColor = [UIColor clearColor];
        }
        else if ([view isKindOfClass:[UIButton class]])
        {
            self.airplayButton = (UIButton*)view;
            [self.airplayButton setImage:[UIImage imageNamed:@"AirplayButton.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)replaceVolumeSliderMethods
{
    static BOOL replacementComplete = NO;
    if (!replacementComplete)
    {
        Method originalThumbRect = class_getInstanceMethod(NSClassFromString(@"MPVolumeSlider"),
                                                           @selector(thumbRectForBounds:trackRect:value:));
        Method newThumbRect = class_getInstanceMethod([GGVolumeSlider class],
                                                      @selector(thumbRectForBounds:trackRect:value:));
        method_exchangeImplementations(originalThumbRect, newThumbRect);
        replacementComplete = YES;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

@end
