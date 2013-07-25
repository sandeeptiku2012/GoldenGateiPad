//
//  GGLabel.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGLabel.h"
#import "GGLabelStylizer.h"

@implementation GGLabel

- (void)commonInit
{
    [[GGLabelStylizer sharedInstance]stylize:self];
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
