//
//  IndentGradientView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "IndentGradientView.h"
#import "GGColor.h"

@implementation IndentGradientView

- (UIView*)borderViewWithFrame:(CGRect)frame
{
    UIView *border = [[UIView alloc]initWithFrame:frame];
    border.backgroundColor = [GGColor darkGoldColor];
    border.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return border;
}

- (void)setupGradient
{
//    [self addColor:[UIColor colorWithWhite: 50.0 / 255 alpha:1.0f] atLocation:0.0f];
//    [self addColor:[UIColor colorWithWhite: 0 / 255 alpha:1.0f] atLocation:0.1f];
//    [self addColor:[UIColor colorWithWhite: 0 / 255 alpha:1.0f] atLocation:0.9f];
//    [self addColor:[UIColor colorWithWhite: 50.0 / 255 alpha:1.0f] atLocation:1.0f];
    
    CGRect borderFrame = self.bounds;
    borderFrame.size.height = 1;
    [self addSubview:[self borderViewWithFrame:borderFrame]];

    borderFrame.origin.y = self.frame.size.height - borderFrame.size.height;
    [self addSubview:[self borderViewWithFrame:borderFrame]];
}

@end
