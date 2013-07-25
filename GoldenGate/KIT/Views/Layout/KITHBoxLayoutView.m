//
//  KITHBoxLayoutView.m
//  KIT
//
//  Created by Andreas Petrov on 2/8/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITHBoxLayoutView.h"

@implementation KITHBoxLayoutView

- (void)commonInit
{
    self.layoutDirection = KITBoxLayoutViewLayoutDirectionHorizontal;
    self.paddingMode = KITBoxLayoutViewPaddingModeAutomatic;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) 
    {
        [self commonInit];
    }
    
    return self;
}

- (id)init
{
    if ((self = [super init])) 
    {
        [self commonInit];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
    {
        [self commonInit];
    }
    
    return self;
}

@end
