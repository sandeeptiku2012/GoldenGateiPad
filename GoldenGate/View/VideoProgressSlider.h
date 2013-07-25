//
//  VideoProgressSlider.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/31/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @abstract This subclass of UISlider is specialized for usage as a video slider.
 Extra features include:
 - Ability to show buffered time ranges
 */
@interface VideoProgressSlider : UISlider

- (void)clearBufferedRanges;
- (void)addBufferedRange:(NSRange)range;

@end
