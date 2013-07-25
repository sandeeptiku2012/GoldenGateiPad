//
//  TopTableFadeoutLightGradientView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/29/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TopTableFadeoutLightGradient.h"

@implementation TopTableFadeoutLightGradient

- (void)setupGradient
{
    [self addColor:[UIColor colorWithWhite: 230.0f / 255 alpha:1.0f] atLocation:0.0f];
    [self addColor:[UIColor colorWithWhite: 230.0f / 255 alpha:0.3f] atLocation:0.4f];
    [self addColor:[UIColor colorWithWhite: 230.0f / 255 alpha:0.0f] atLocation:1.0f];
}

@end
