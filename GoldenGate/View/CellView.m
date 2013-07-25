//
//  TileView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CellView.h"

#import "GGColor.h"

#import <QuartzCore/QuartzCore.h>

#define kSelectionAnimationScaleFactor 1.15
#define kSelectionAnimationDuration 0.2

#define kBorderColor [UIColor colorWithWhite:150.0f / 255 alpha:1.0f]
#define kBorderColorHighlighted [GGColor lightGoldColor]

@interface CellView()

@property (weak, nonatomic) IBOutlet UIView *frameView;

@end

@implementation CellView

+ (NSString*)nibNameForCellSize:(CellSize)size class:(Class)class
{
    NSString *sizePostfix = nil;
    
    switch (size) {
        case CellSizeSmall:
            sizePostfix = @"Small";
            break;
        case CellSizeLarge:
            sizePostfix = @"Large";
            break;
        case CellSizeSquare:
            sizePostfix = @"Square";
            break;
        case CellSizeLong:
            sizePostfix = @"Long";
            break;
        case CellSizeLargeTextRight:
            sizePostfix = @"LargeTextRight";
            break;
        case CellSizeLargeTextBelow:
            sizePostfix = @"LargeTextBelow";
            break;
        case CellSizeTable:
            sizePostfix = @"Table";
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",NSStringFromClass(class), sizePostfix];
}

- (id)initWithCellSize:(CellSize)size subclass:(Class)subclass
{
    NSString *nibName = [CellView nibNameForCellSize:size class:subclass];
    UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    contentView.userInteractionEnabled = NO;
    self.frameView.backgroundColor = kBorderColor;
    
    if ((self = [self initWithFrame:contentView.frame]))
    {
        _cellSize = size;
        self.backgroundColor = [UIColor clearColor]; // Get rid of IB placeholder.
        [self addSubview:contentView];
//        self.frameView.layer.shadowColor = [[UIColor blackColor]CGColor];
//        self.frameView.layer.shadowRadius = 2;
//        self.frameView.clipsToBounds = NO;
//        self.frameView.backgroundColor = [UIColor grayColor];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.frameView.backgroundColor = highlighted || self.selected ? kBorderColorHighlighted : kBorderColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.frameView.backgroundColor = selected ? kBorderColorHighlighted : kBorderColor;
    
    if(selected && self.animateSelection)
    {
        [self performAnimateSelection];
    }
}

- (void)performAnimateSelection
{
    CATransform3D scaleTransform = CATransform3DMakeScale(kSelectionAnimationScaleFactor, kSelectionAnimationScaleFactor, 1);
    NSArray *keyFrameValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:scaleTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
    
    CAKeyframeAnimation *pulseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    pulseAnimation.values   = keyFrameValues;
    pulseAnimation.duration = kSelectionAnimationDuration;
    pulseAnimation.removedOnCompletion = YES;
    pulseAnimation.fillMode = kCAFillModeForwards;
    pulseAnimation.keyTimes = [NSArray arrayWithObjects:@(0.3), @(1.0), nil];
    
    [self.frameView.layer addAnimation:pulseAnimation forKey:@"transform"];
}


- (void)replaceDataObject:(NSObject*)dataObject
{
    // DO NOTHING. Reimpl. in subclasses
}

- (NSObject*)fetchDataObject
{
    return nil;
}

- (void)styleForLightBackground
{
    NSAssert(NO, @"Please implement this method for the CellView subclass");
}

@end
