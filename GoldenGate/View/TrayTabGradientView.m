//
//  TrayTabGradientView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/7/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TrayTabGradientView.h"

@implementation TrayTabGradientView

- (void)setupGradient
{
    [self addColor:[UIColor colorWithWhite: 70.0/ 255 alpha:0.5f] atLocation:0.0f];
//    [self addColor:[UIColor colorWithWhite: 50.0/ 255 alpha:0.9f] atLocation:0.7f];
    [self addColor:[UIColor colorWithWhite: 10.0/ 255 alpha:1.0f] atLocation:1.0f];
}

@end
