//
//  GGNavigationBar.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGNavigationBar.h"

@implementation GGNavigationBar

- (void)commonInit
{
    [self setBackgroundImage:[UIImage imageNamed:@"NavBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
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



@end
