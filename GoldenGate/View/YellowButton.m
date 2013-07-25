//
//  YellowButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "YellowButton.h"
#import "GGLabelStylizer.h"

#define kVerticalTextOffset 4
#define kImageInset 10
#define kImageName @"YellowButton.png"

@implementation YellowButton

- (void)commonInit
{
    [[GGLabelStylizer sharedInstance]stylize:self.titleLabel];
    
    UIImage *image = [[UIImage imageNamed:kImageName]resizableImageWithCapInsets:UIEdgeInsetsMake(0, kImageInset, 0, kImageInset)];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = ((self.frame.size.height / 2) - (frame.size.height / 2)) + kVerticalTextOffset;
    self.titleLabel.frame = frame;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
