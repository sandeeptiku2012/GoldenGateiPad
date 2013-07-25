//
//  GGVolumeSlider.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/7/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGVolumeSlider.h"

@implementation GGVolumeSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds
                   trackRect:(CGRect)rect
                       value:(float)value
{
    CGRect modifiedRect =  [super thumbRectForBounds:bounds
                           trackRect:rect
                               value:value];
    
    CGFloat trackCenter = rect.origin.y + (rect.size.height / 2);
    modifiedRect.origin.y = (int)(trackCenter - (modifiedRect.size.height / 2));
    return modifiedRect;
}


@end
