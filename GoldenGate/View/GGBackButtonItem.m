//
//  GGBackButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/24/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBackButtonItem.h"

#import "GGLabelStylizer.h"

#define kImageName @"BackButtonBg.png"
#define kImageInset 6

#define kVerticalTextOffset 2

@interface GGBackButton : UIButton

@end

@implementation GGBackButton

- (void)commonInit
{
    [[GGLabelStylizer sharedInstance]stylize:self.titleLabel];
    
    UIImage *image = [[UIImage imageNamed:kImageName]resizableImageWithCapInsets:UIEdgeInsetsMake(0, kImageInset, 0, kImageInset)];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
    [self setTitle:NSLocalizedString(@"BackLKey", @"") forState:UIControlStateNormal];
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


@end


@implementation GGBackButtonItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
//        UIImage *image = [[UIImage imageNamed:kImageName]resizableImageWithCapInsets:UIEdgeInsetsMake(0, kImageInset, 0, kImageInset)];
//        [self setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [self setTitleTextAttributes:<#(NSDictionary *)#> forState:<#(UIControlState)#>]
//        CGRect frame = CGRectMake(0, 0, self.width, 45);
//        GGBackButton *backButton = [[GGBackButton alloc]initWithFrame:frame];
//        [self setCustomView:backButton];
//        self.customView
    }
    
    return self;
}

@end

