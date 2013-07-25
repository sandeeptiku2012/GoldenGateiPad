//
//  GGBarButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/16/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBarButton.h"
#import "GGColor.h"
#import "GGLabelStylizer.h"

#define kImagePadding 6
#define kButtonMargins 8
#define kFontSize 13

@implementation GGBarButton

+ (CGFloat)buttonMargins
{
    return kButtonMargins;
}


+ (CGFloat)imagePadding
{
    return kImagePadding;
}

- (void)commonInit
{
    UIImage *image = [[UIImage imageNamed:@"BarButtonBg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    self.titleLabel.font = [[GGLabelStylizer sharedInstance]stylizedFontFromSystemFont:[UIFont boldSystemFontOfSize:kFontSize]];
    self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.shadowColor  = [UIColor blackColor];
    [self setTitleColor:[GGColor veryLightGrayColor] forState:UIControlStateNormal];
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
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageEdgeInsets = UIEdgeInsetsMake(1, self.frame.size.width - (kImagePadding * 2) - self.imageView.frame.size.width, 0, kImagePadding);
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    // Add extra inset if there is an image present in the barbutton
    CGFloat imageInset = image != nil ? self.imageView.frame.size.width + (kImagePadding * 2) : 0;
    self.titleEdgeInsets = UIEdgeInsetsMake(9, kButtonMargins, 5,imageInset + kButtonMargins);
}

@end
