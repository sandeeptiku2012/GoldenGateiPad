//
//  GradientView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface GradientView()

@property (strong, nonatomic) NSMutableArray *gradientColors;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) CAGradientLayer*gradientLayer;

@end

@implementation GradientView

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    [self setupGradient];
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

- (void)setupGradient
{
    // Do nothing here. Reimpl in subclasses.
}

- (void)addColor:(UIColor*)color atLocation:(CGFloat)location
{
    [self.gradientColors addObject:color];
    [self.locations addObject:@(location)];
    

    NSMutableArray *cgColorArray = [NSMutableArray new];
    for (UIColor *uicolor in self.gradientColors)
    {
        [cgColorArray addObject:(__bridge id)uicolor.CGColor];
    }
    
    self.gradientLayer.colors = cgColorArray;
    self.gradientLayer.locations = self.locations;
}

- (NSMutableArray*)gradientColors
{
    if (_gradientColors == nil)
    {
        _gradientColors = [NSMutableArray new];
    }
    
    return _gradientColors;
}

- (NSMutableArray*)locations
{
    if (_locations == nil)
    {
        _locations = [NSMutableArray new];
    }
    
    return _locations;
}

- (CAGradientLayer*)gradientLayer
{
    if (_gradientLayer == nil)
    {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [self.layer addSublayer:gradientLayer];
        _gradientLayer = gradientLayer;
    }
    
    return _gradientLayer;
}


@end
