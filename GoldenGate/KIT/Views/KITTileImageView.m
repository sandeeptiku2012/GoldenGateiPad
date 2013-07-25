//
//  KITTileImageView.m
//  KIT
//
//  Created by Andreas Petrov on 7/16/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITTileImageView.h"

@implementation KITTileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.image = self.image;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    UIImage *tiledImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [super setImage:tiledImage];
}

@end
