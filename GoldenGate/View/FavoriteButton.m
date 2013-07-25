//
//  FavoriteButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoriteButton.h"

#define kWidthPadding 15

@implementation FavoriteButton

- (void)commonInit
{
    UIImage *image = [UIImage imageNamed:@"HollowFavoriteStar.png"];
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"HollowFavoriteStarActive.png"] forState:UIControlStateSelected];
    
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
