//
//  GGCheckBoxButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "GGCheckBoxButton.h"

@implementation GGCheckBoxButton


#pragma mark - Init

- (void)commonInit
{
    [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxOn.png"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxOff.png"] forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setTitle:@"" forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(didPressButton) forControlEvents:UIControlEventTouchUpInside];
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) 
    {
        [self commonInit];
    }
    
    return self;
}

- (void)didPressButton
{
    self.selected = !self.selected;
}



@end
