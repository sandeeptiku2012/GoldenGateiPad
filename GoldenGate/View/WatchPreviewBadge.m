//
//  WatchPreviewBadge.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "WatchPreviewBadge.h"

#import "GradientView.h"

#import "GGColor.h"

#import <QuartzCore/QuartzCore.h>

@interface WatchPreviewBadge()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet GradientView *gradientView;
@property (strong, nonatomic) IBOutlet UIImageView *playIcon;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation WatchPreviewBadge

- (void)commonInit
{
    self.contentView = [[[NSBundle mainBundle]loadNibNamed:@"WatchPreviewBadge"
                                                       owner:self
                                                     options:nil]objectAtIndex:0];
    
    [self addSubview:self.contentView];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self updateFromMode:self.mode];
}

-  (id)initWithCoder:(NSCoder *)aDecoder
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

- (void)updateFromMode:(WatchPreviewBadgeMode)mode
{
    self.textLabel.text = mode == WatchPreviewBadgeModePreview ? NSLocalizedString(@"PreviewLKey", @"") : NSLocalizedString(@"WatchLKey", @"") ;
    
    self.gradientLayer.colors = mode == WatchPreviewBadgeModePreview ?
        [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:94.0f / 255  alpha:1].CGColor,
                                  (id)[UIColor colorWithWhite:70.0f / 255 alpha:1].CGColor, nil] :
        [NSArray arrayWithObjects:(id)[GGColor lightGoldColor].CGColor,
                                  (id)[GGColor darkGoldColor].CGColor,nil] ;
    
}

- (void)setMode:(WatchPreviewBadgeMode)mode
{
    _mode = mode;
    
    [self updateFromMode:mode];
}

-  (void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    CGFloat newWidth = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + self.playIcon.frame.origin.x;
    self.contentView.frame = CGRectMake(0, 0, newWidth, self.contentView.bounds.size.height);
    self.gradientLayer.frame = self.backgroundView.frame;
}

- (CAGradientLayer*)gradientLayer
{
    if (_gradientLayer == nil)
    {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.backgroundView.frame;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        _gradientLayer = gradientLayer;
    }
    
    return _gradientLayer;
}

@end
