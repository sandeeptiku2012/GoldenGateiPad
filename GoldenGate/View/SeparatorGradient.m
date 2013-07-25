//
//  SeparatorGradient.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SeparatorGradient.h"

@implementation SeparatorGradient

- (void)setupGradient
{
    [self addColor:[UIColor colorWithWhite: 25.0/ 255 alpha:1.0f] atLocation:0.0f];
    [self addColor:[UIColor colorWithWhite: 0/ 255 alpha:0.0f] atLocation:1.0f];
}

@end
