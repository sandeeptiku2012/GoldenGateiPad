//
//  GGPopoverBackgroundView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGPopoverBackgroundView.h"

@interface GGPopoverBackgroundView()

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIImageView *arrow;

@end

static UIImage *gArrowImage;

@implementation GGPopoverBackgroundView
{
    UIPopoverArrowDirection _arrowDirection;
    CGFloat _arrowOffset;
}

+ (void)initialize
{
    if (gArrowImage == nil)
    {
        gArrowImage = [UIImage imageNamed:@"PopoverArrow.png"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        UIImage *image = [[UIImage imageNamed:@"PopoverBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 16, 16, 16)];
        self.background = [[UIImageView alloc] initWithImage:image];
        self.arrow = [[UIImageView alloc]initWithImage:gArrowImage];
        
        [self addSubview:self.background];
        [self addSubview:self.arrow];
    }

    return self;
}

-(void)layoutSubviews
{
    if (self.arrowDirection == UIPopoverArrowDirectionUp)
    {
        CGFloat height = [[self class] arrowHeight];
        CGFloat base = [[self class] arrowBase];

        self.background.frame = CGRectMake(0, height, self.frame.size.width, self.frame.size.height - height);

        self.arrow.frame = CGRectMake(self.frame.size.width * 0.5 + self.arrowOffset - base * 0.5, 1.0, base, height);
        [self bringSubviewToFront:self.arrow];
    }
}


#pragma mark - Properties

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

- (void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
}

- (CGFloat)arrowOffset
{
    return _arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection
{
    return _arrowDirection;
}

+ (CGFloat)arrowHeight
{
    return gArrowImage.size.height;
}

+ (CGFloat)arrowBase
{
    return gArrowImage.size.width;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
