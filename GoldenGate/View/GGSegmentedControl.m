//
//  GGSegmentedControl.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGSegmentedControl.h"

#import "GGLabelStylizer.h"
#import "Constants.h"


#define kMinimumSegmentWidth 90

@implementation GGSegmentedControl
{
    BOOL hasUpdatedWidth;
}

- (void)commonInit
{
    self.segmentedControlStyle = UISegmentedControlStyleBar;

    // Custom background images
    UIImage *normalImage    = [[UIImage imageNamed:@"BarButtonBg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *selectedImage  = [[UIImage imageNamed:@"SegmentedControlBgSelected.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    [self setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setDividerImage:[UIImage imageNamed:@"SeparatorPixel.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    
    // Add custom font
    UIFont *font = [[GGLabelStylizer sharedInstance]stylizedFontFromSystemFont:[UIFont boldSystemFontOfSize:12.0f]];
    NSDictionary *attributes = [GGLabelStylizer textPropertyDictWithFontSize:font.pointSize];

    [self setTitleTextAttributes:attributes
                        forState:UIControlStateNormal];
    [self setTitleTextAttributes:attributes
                        forState:UIControlStateSelected];
    [self setTitleTextAttributes:attributes
                        forState:UIControlStateHighlighted];

    
    
    // Offset text labels a bit because of the new font
    [self setContentPositionAdjustment:UIOffsetMake(0, kVertialTextOffset) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    
    self.usesFixedWidth = YES;
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

- (id)initWithItems:(NSArray *)items
{
    if ((self = [super initWithItems:items]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)updateSegmentWidth
{
    // Ensure segments have a minimum width
    int totalWidth = 0;
    for (int i = 0; i < self.numberOfSegments ;++i)
    {
        CGFloat widthForSegment = [self widthForSegmentAtIndex:i];
        if (widthForSegment < kMinimumSegmentWidth)
        {
            totalWidth += kMinimumSegmentWidth;
            [self setWidth:kMinimumSegmentWidth forSegmentAtIndex:i];
        }
        else
        {
            totalWidth += widthForSegment;
        }
    }
    
    CGFloat dividerWidth = (self.numberOfSegments - 1);
    CGRect frame = self.frame;
    frame.size.width = totalWidth + dividerWidth;
    self.frame = frame;
    hasUpdatedWidth = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!hasUpdatedWidth && self.usesFixedWidth)
    {
        [self updateSegmentWidth];
    }
}

@end
