//
//  LikeButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/24/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LikeButton.h"

#define kWidthPadding 15

@implementation LikeButton

- (void)commonInit
{
    UIImage *image = [UIImage imageNamed:@"LikeIconBig.png"];
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"LikeIconBigActive.png"] forState:UIControlStateSelected];
    
    self.frame = CGRectMake(0, 0, image.size.width + kWidthPadding, image.size.height);
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
    self = [super initWithFrame:frame];
    if (self)
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


@end
