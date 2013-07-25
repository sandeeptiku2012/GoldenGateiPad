//
//  VideoProgressSlider.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/31/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VideoProgressSlider.h"
#import <QuartzCore/QuartzCore.h>

#define kBarCornerRadius 5

@interface VideoProgressSlider()

@property (strong, nonatomic) NSMutableArray *bufferedRanges;
@property (strong, nonatomic) NSMutableArray *bufferedContentBars;
@property (weak, nonatomic) UIImageView *minTrack;
@property (weak, nonatomic) UIImageView *maxTrack;


@end

@implementation VideoProgressSlider


- (void)commonInit
{
    self.bufferedContentBars    = [NSMutableArray new];
    self.bufferedRanges         = [NSMutableArray new];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
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

- (UIImageView*)createBufferedContentBar
{
    UIImageView *bufferedContentBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BufferedContentGradient.png"]];
    bufferedContentBar.layer.cornerRadius = kBarCornerRadius;
    bufferedContentBar.clipsToBounds = YES;
    return bufferedContentBar;
}

- (void)clearBufferedRanges
{    
    [self.bufferedRanges removeAllObjects];
}

- (void)addBufferedRange:(NSRange)range
{
    [self.bufferedRanges addObject:[NSValue valueWithRange:range]];
}

- (void)clearBufferedContentBars
{
    for (UIView *view in self.bufferedContentBars)
    {
        [view removeFromSuperview];
    }
    
    [self.bufferedContentBars removeAllObjects];
}

- (void)updateBufferedContentBarCount
{
    if (self.minTrack == nil)
    {
        // Assign existing subviews to convenient properties for later use before adding
        // loads of other subviews.
        self.minTrack  = [self.subviews objectAtIndex:1];
        self.maxTrack  = [self.subviews objectAtIndex:0];
    }
    
    [self clearBufferedContentBars];
    
    for (int i = 0; i < self.bufferedRanges.count; ++i)
    {
        UIView *bufferedContentBar = [self createBufferedContentBar];
        
        [self.bufferedContentBars addObject:bufferedContentBar];
        // Insert the buffered content bar BELOW the progress bar
        [self insertSubview:bufferedContentBar belowSubview:self.minTrack];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL bufferedBarCountChanged = self.bufferedContentBars.count != self.bufferedRanges.count;
    if (bufferedBarCountChanged)
    {
        [self updateBufferedContentBarCount];
    }
    
    float sliderAreaWidth = self.minTrack.bounds.size.width + self.maxTrack.bounds.size.width;
    float valueDiff = self.maximumValue - self.minimumValue;
    float widthPrUnit = sliderAreaWidth / valueDiff;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 0; i < self.bufferedRanges.count; ++i)
        {
            NSValue *range = [self.bufferedRanges objectAtIndex:i];
            NSRange rangeVal = range.rangeValue;
            
            UIView *bufferedContentBar = [self.bufferedContentBars objectAtIndex:i];
            
            float bufferedContentBarXOrigin = widthPrUnit * rangeVal.location;
            float bufferedContentBarWidth   = widthPrUnit * rangeVal.length;
            
            CGRect bufferedContentFrame     = self.minTrack.frame;

            bufferedContentFrame.origin.x   = (int)bufferedContentBarXOrigin;
            bufferedContentFrame.size.width = (int)bufferedContentBarWidth;
            bufferedContentBar.frame        = bufferedContentFrame;
        }
    } completion:nil];
}


@end
