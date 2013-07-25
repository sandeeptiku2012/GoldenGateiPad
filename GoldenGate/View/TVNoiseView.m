//
//  TVNoiseView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/16/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TVNoiseView.h"

#define kAnimationFrameCount 4
#define kAnimationDuration 0.3

@implementation TVNoiseView

- (void)commonInit
{
    [self rebuildAnimationImagesList];
    [self startAnimating];
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
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    
    return self;
}

- (NSString*)imageNameForFrame:(NSInteger)frame
{
    return [NSString stringWithFormat:@"WhiteNoise%d.png", frame + 1];
}

- (void)rebuildAnimationImagesList
{
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:kAnimationFrameCount];
    for (int i = 0; i < kAnimationFrameCount; ++i)
    {
        UIImage *image = [UIImage imageNamed:[self imageNameForFrame:i]];
        [images addObject:[image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
    }
    
    self.animationDuration = kAnimationDuration;
    self.animationRepeatCount = 0; // Loop until stopped.
    self.animationImages = images;
}

@end
