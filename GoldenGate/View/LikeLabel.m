//
//  LikeLabel.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LikeLabel.h"

#define kLikeIconViewPadding 5

@interface LikeLabel()

@property (weak, nonatomic) IBOutlet UIImageView *likeIconView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation LikeLabel

- (void)commonInit
{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"LikeLabel"
                                                        owner:self
                                                      options:nil]objectAtIndex:0];
    self.backgroundColor = [UIColor clearColor]; // Get rid of IB placeholder color 
    
    [self addSubview:contentView];
    
    [self updateText];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.likeCountLabel sizeToFit];
    
    CGRect iconFrame = self.likeIconView.frame;

    // Make sure icon always is kLikeIconViewPadding away from the end of the like count label regardless of its size.
    iconFrame.origin.x =
        self.likeCountLabel.frame.origin.x +
        self.likeCountLabel.frame.size.width +
        kLikeIconViewPadding;
    
    self.likeIconView.frame = iconFrame;
}

- (NSString *)createTruncatedNumberString:(int)number
{
    NSString *truncNumberString = nil;
    int numberOfThousands = _likeCount / 1000;
    if (numberOfThousands > 0)
    {
        NSString *nrOfThousandsString = [NSString stringWithFormat:@"%d", numberOfThousands];
        NSString *fullNumberString = [NSString stringWithFormat:@"%d",number];
        int digitsUsedForRepresentingThousands = nrOfThousandsString.length;
        unichar firstNonThousandDigit = [fullNumberString characterAtIndex:digitsUsedForRepresentingThousands];
        BOOL nonZeroDigit = firstNonThousandDigit != '0';
        if (nonZeroDigit)
        {
            NSString *truncatedLikeCountString = [NSString stringWithFormat:@"%d.%Ck",numberOfThousands, firstNonThousandDigit];
            truncNumberString = truncatedLikeCountString;
        }
        else
        {
            NSString *truncatedLikeCountString = [NSString stringWithFormat:@"%dk",numberOfThousands];
            truncNumberString = truncatedLikeCountString;
        }
    }

    return truncNumberString;
}

- (void)updateText
{
    NSString *likeCountString = [NSString stringWithFormat:@"%d", _likeCount];
    
    int needsTruncation = (_likeCount / 1000) > 0;
    if (needsTruncation)
    {
        likeCountString = [self createTruncatedNumberString:_likeCount];
    }
    
    self.likeCountLabel.text = likeCountString;
    
    [self setNeedsLayout];
}

- (void)setLikeCount:(int)likeCount
{
    _likeCount = likeCount;
    
    [self updateText];
}

@end
