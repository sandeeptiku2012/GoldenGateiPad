//
//  GrayBgGradientView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GrayBgGradientView.h"

@implementation GrayBgGradientView

- (void)setupGradient
{
    [self addColor:[UIColor colorWithWhite: 70.0/ 255 alpha:1.0f] atLocation:0.0f];
    [self addColor:[UIColor colorWithWhite: 96.0/ 255 alpha:1.0f] atLocation:0.4f];
    [self addColor:[UIColor colorWithWhite: 96.0/ 255 alpha:1.0f] atLocation:0.6f];
    [self addColor:[UIColor colorWithWhite: 65.0/ 255 alpha:1.0f] atLocation:1.0f];
}

@end
