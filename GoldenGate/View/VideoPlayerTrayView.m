//
//  VideoPlayerTrayView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/6/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VideoPlayerTrayView.h"

#import "KITGridLayoutView.h"

#import <QuartzCore/QuartzCore.h>

#define kExpandContractAnimDuration 0.2
#define kLeftContentMargin 10
#define kFadeAlpha 0.4

@interface VideoPlayerTrayView()

@property (weak, nonatomic) IBOutlet UIScrollView *dynamicContentScrollView;
@property (weak, nonatomic) IBOutlet UIView *dynamicBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tabImageView;

@property (assign, nonatomic) int selectedIndex;

@end

@implementation VideoPlayerTrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"VideoPlayerTrayView" owner:self options:nil]objectAtIndex:0];
    if ((self = [super initWithCoder:aDecoder]))
    {
        contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:contentView];
        self.backgroundColor = [UIColor clearColor]; // Remove IB placeholder color
        self.trayTabView.layer.cornerRadius = 10;
        self.trayTabView.clipsToBounds = YES;

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishContracting:)  name:kNotificationTrayViewDidFinishContracting object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didStartExpanding:)     name:kNotificationTrayViewDidStartExpanding object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didStartDragging:)      name:kNotificationTrayViewDidStartDragging object:self];
        
        self.expansionAnimationDuration  = kExpandContractAnimDuration;
        self.contractionAnimationDuration= kExpandContractAnimDuration;
        self.dynamicContentContainer.leftMargin = kLeftContentMargin;
        
        self.dynamicContentScrollView.hidden = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)clearDynamicContent
{
    // reset content size width
    CGSize contentSize = self.dynamicContentScrollView.contentSize;
    contentSize.width = 0;
    self.dynamicContentScrollView.contentSize = contentSize;
    
    for (UIView *view in self.dynamicContentContainer.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)addViewToDynamicContent:(UIView *)view
{
    // Update the scrollview content size
    CGFloat widthForView = view.frame.size.width + self.dynamicContentContainer.horizontalGridSpacing;
    CGSize contentSize = self.dynamicContentScrollView.contentSize;
    contentSize.width += widthForView;
    contentSize.height = self.dynamicContentScrollView.bounds.size.height;
    self.dynamicContentScrollView.contentSize = contentSize;

    // Update the size of the grid layout view
    CGRect layoutViewFrame = self.dynamicContentContainer.frame;
    layoutViewFrame.size = contentSize;
    self.dynamicContentContainer.frame = layoutViewFrame;

    
    [self.dynamicContentContainer addSubview:view];

}

- (void)selectDynamicContentAtIndex:(int)index
{
    self.selectedIndex = index;
    
    [self clearDynamicContentHighlight];
    if (index != -1)
    {
        if ([self.dynamicContentContainer.subviews count]> index) {
            UIView *contentAtIndex = [self.dynamicContentContainer.subviews objectAtIndex:index];
            [self selectObject:contentAtIndex selected:YES];
            [self scrollToDynamicContentAtIndex:index animated:YES];
        }

    }
    
    if (self.fadeItemsToLeftOfActive)
    {
        [self performFadeItemsToLeftOfActive];
    }
}

- (void)scrollToDynamicContentAtIndex:(int)index animated:(BOOL)animated
{
    if (index != -1 && index < self.dynamicContentContainer.subviews.count)
    {
        UIView *contentAtIndex = [self.dynamicContentContainer.subviews objectAtIndex:index];
        CGFloat widthPrItem = (contentAtIndex.frame.size.width + self.dynamicContentContainer.horizontalGridSpacing);
        int numberOfButtonsFittingInTheScroller = self.dynamicContentScrollView.frame.size.width / widthPrItem;
        CGRect scrollFrame = CGRectMake(contentAtIndex.frame.origin.x - self.dynamicContentContainer.leftMargin,
                                        self.dynamicContentScrollView.frame.origin.y,
                                        widthPrItem * numberOfButtonsFittingInTheScroller,
                                        contentAtIndex.frame.size.height);
        [self.dynamicContentScrollView scrollRectToVisible:scrollFrame animated:animated];
    }
}

- (void)selectObject:(id)object selected:(BOOL)selected
{
    // This method is needed because performSelector:withObject: doesn't support BOOL
    if ([object respondsToSelector:@selector(setSelected:)])
    {
        NSMethodSignature *m = [object methodSignatureForSelector:@selector(setSelected:)];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:m];
        inv.target = object;
        inv.selector = @selector(setSelected:);
        
        BOOL selectedArg = selected;
        [inv setArgument:&selectedArg atIndex:2];
        [inv retainArguments];
        [inv invoke];
    }
}

- (void)clearDynamicContentHighlight
{
    for (id view in self.dynamicContentContainer.subviews)
    {
        [self selectObject:view selected:NO];
    }
}

- (void)resetDynamicContentAlpha
{
    for (UIView *view in self.dynamicContentContainer.subviews)
    {
        view.alpha = 1;
    }
}

- (void)performFadeItemsToLeftOfActive
{
    [self resetDynamicContentAlpha];
    
    int iCountSubviews = [self.dynamicContentContainer.subviews count];
    for (int i = 0; i < self.selectedIndex; ++i)
    {
        if (iCountSubviews>i) {
            UIView* view = [self.dynamicContentContainer.subviews objectAtIndex:i];
            view.alpha = kFadeAlpha;
        }
       
    }
}

#pragma mark - Properties

- (void)setTabLabelString:(NSString *)tabLabelString
{
    self.tabLabel.text = tabLabelString;
    [self.tabLabel sizeToFit];
    CGRect frame = self.trayTabView.frame;
    frame.size.width = self.tabLabel.frame.origin.x + self.tabLabel.frame.size.width + self.tabImageView.frame.origin.x;
    self.trayTabView.frame = frame;
}

- (NSString*)tabLabelString
{
    return self.tabLabel.text;
}

- (void)setTabIconImage:(UIImage *)tabIconImage
{
    self.tabImageView.image = tabIconImage;
}

- (UIImage*)tabIconImage
{
    return self.tabImageView.image;
}

#pragma mark - Event handlers

- (void)didFinishContracting:(NSNotification*)notification
{

    // Hide the scrollview as it should save rendering performance.
    self.dynamicContentScrollView.hidden = YES;
}

- (void)didStartExpanding:(NSNotification*)notification
{

    self.dynamicContentScrollView.hidden = NO;
    [self scrollToDynamicContentAtIndex:self.selectedIndex animated:NO];
}

- (void)didStartDragging:(NSNotification*)notification
{
    self.dynamicContentScrollView.hidden = NO;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect tabFrame = self.trayTabView.frame;
    CGRect backgroundFrame = self.bounds;
    
    if (self.tabLocation == VideoPlayerTrayViewTabLocationAbove)
    {
        tabFrame.origin.y = -tabFrame.size.height;
        backgroundFrame.size.height += self.bouncePadding;
    }
    else if (self.tabLocation == VideoPlayerTrayViewTabLocationBelow)
    {
        tabFrame.origin.y = self.frame.size.height;
        
        backgroundFrame.origin.y -= self.bouncePadding - 1; // One extra pixel to make sure tab overlaps properly
        backgroundFrame.size.height += self.bouncePadding;
    }
    
    self.dynamicBackgroundView.frame = backgroundFrame;
//    self.trayTabView.frame = tabFrame;
}

@end
