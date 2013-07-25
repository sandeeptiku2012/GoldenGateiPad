//
//  LoadingView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/24/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel    *loadingTextLabel;
@property (weak, nonatomic) IBOutlet UILabel    *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton   *retryButton;

@end

@implementation LoadingView

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor]; // remove IB placeholder.
    self.hidden = YES;
    
    [self updateFromStyle:self.style];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
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

- (void)startLoadingWithText:(NSString*)string
{
    // If spinner already is animating don't start it again.
    if (self.spinner.isAnimating)
    {
        return;
    }
    
    self.loadingTextLabel.text = string;
    self.hidden = NO;
    self.loadingTextLabel.hidden = NO;
    self.retryButton.hidden = YES;
    self.errorMessageLabel.hidden = YES;
    [self.spinner startAnimating];
}

- (void)showRetryWithMessage:(NSString*)message
{
    self.hidden = NO;
    self.errorMessageLabel.hidden = NO;
    self.errorMessageLabel.text = message;
    [self.spinner stopAnimating];
    self.retryButton.hidden = NO;
    [self.retryButton setTitle:NSLocalizedString(@"RetryLKey", @"") forState:UIControlStateNormal];
    self.loadingTextLabel.hidden = YES;
}

- (void)showMessage:(NSString*)message
{
    self.hidden = NO;
    self.errorMessageLabel.hidden = NO;
    self.errorMessageLabel.text = message;
    [self.spinner stopAnimating];
    self.retryButton.hidden = YES;
    self.loadingTextLabel.hidden = YES;
}

- (void)endLoading
{
    [self.spinner stopAnimating];
    self.hidden = YES;
    self.loadingTextLabel.hidden = YES;
    self.errorMessageLabel.hidden = YES;
    self.retryButton.hidden = YES;
}


- (void)didPressRetryButton
{
    if ([self.delegate respondsToSelector:@selector(retryButtonWasPressedInLoadingView:)])
    {
        [self.delegate retryButtonWasPressedInLoadingView:self];
    }
}

- (void)updateFromStyle:(LoadingViewStyle)style
{
    UIView *existingContent = [self.subviews lastObject];
    [existingContent removeFromSuperview];
    
    NSString *nibName = self.style == LoadingViewStyleForDarkBackground ? @"LoadingViewForDarkBackground" : @"LoadingViewForLightBackground";
    UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [contentView setNeedsLayout];
    [self.retryButton addTarget:self action:@selector(didPressRetryButton) forControlEvents:UIControlEventTouchUpInside];
    self.spinner.hidesWhenStopped = YES;
    [self addSubview:contentView];
}

- (void)setStyle:(LoadingViewStyle)style
{
    _style = style;
    
    [self updateFromStyle:style];
}

@end
