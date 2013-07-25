//
//  KITBoxLayoutView.m
//  KIT
//
//  Created by Andreas Petrov on 2/8/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITBoxLayoutView.h"

@implementation KITBoxLayoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutInDirection:(KITBoxLayoutViewLayoutDirection)direction
{
    int verticalDirectionFactor = direction == KITBoxLayoutViewLayoutDirectionVertical ? 1 : 0;
    int horizontalDirectionFactor = direction == KITBoxLayoutViewLayoutDirectionHorizontal ? 1 : 0;
    
    NSMutableArray *originalFrames = nil;
    
    if (self.paddingMode == KITBoxLayoutViewPaddingModeAutomatic)
    {
        // Store view positions so that relative distance between them can be calculated later on.
        // Only needed for automatic padding mode.
        originalFrames = [[NSMutableArray alloc]initWithCapacity:self.subviews.count];
        for (UIView *subview in self.subviews) 
        {
            [originalFrames addObject:[NSValue valueWithCGRect:subview.frame]];
        }
    }

    
    for (int i = 1; i < self.subviews.count; ++i) 
    {
        int previousViewIndex = i - 1;
        UIView *previousView    = [self.subviews objectAtIndex: previousViewIndex];
        UIView *currentView     = [self.subviews objectAtIndex: i];
        
        CGRect previousViewFrame    = originalFrames != nil ? [[originalFrames objectAtIndex: previousViewIndex]CGRectValue] : previousView.frame;
        CGRect currentViewFrame     = currentView.frame;
        
        float xDistanceBetweenCurrentAndPreviousBeforeLayout = currentView.frame.origin.x - (previousViewFrame.origin.x + previousViewFrame.size.width); 
        float newXOrigin = previousView.frame.origin.x + previousView.frame.size.width;
        newXOrigin += self.paddingMode == KITBoxLayoutViewPaddingModeAutomatic ? xDistanceBetweenCurrentAndPreviousBeforeLayout : _paddingSize;
        
        float yDistanceBetweenCurrentAndPreviousBeforeLayout = currentView.frame.origin.y - (previousViewFrame.origin.y + previousViewFrame.size.height); 
        float newYOrigin = previousView.frame.origin.y + previousView.frame.size.height;
        newYOrigin += self.paddingMode == KITBoxLayoutViewPaddingModeAutomatic ? yDistanceBetweenCurrentAndPreviousBeforeLayout : _paddingSize;

        // Calculate offset compared to pre-layout view position
        float deltaX = (newXOrigin - currentViewFrame.origin.x) * horizontalDirectionFactor;
        float deltaY = (newYOrigin - currentViewFrame.origin.y) * verticalDirectionFactor;
        
        currentView.frame = CGRectOffset(currentViewFrame, deltaX, deltaY);
    }
}

- (void)layoutSubviews
{
//    [super layoutSubviews];
    
    [self layoutInDirection: self.layoutDirection];
}

#pragma mark - Properties

- (void)setPaddingMode:(KITBoxLayoutViewPaddingMode)aPaddingMode
{
    BOOL needsToUpdateLayout = _paddingMode != aPaddingMode;
    if (needsToUpdateLayout) 
    {
        [self setNeedsLayout];
    }
    
    _paddingMode = aPaddingMode;
}

- (void)setLayoutDirection:(KITBoxLayoutViewLayoutDirection)aLayoutDirection
{
    BOOL needsToUpdateLayout = _layoutDirection != aLayoutDirection;
    if (needsToUpdateLayout) 
    {
        [self setNeedsLayout];
    }
    
    _layoutDirection = aLayoutDirection;
}

- (void)setPaddingSize:(CGFloat)aPaddingSize
{
    BOOL needsToUpdateLayout = _paddingSize != aPaddingSize && _paddingMode == KITBoxLayoutViewPaddingModeManual;
    if (needsToUpdateLayout) 
    {
        [self setNeedsLayout];
    }
    
    _paddingSize = aPaddingSize;
}

@end
