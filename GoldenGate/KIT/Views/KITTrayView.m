//
//  KITTrayView+.m
//  KIT
//
//  Created by Andreas Petrov on 9/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "KITTrayView.h"

#define kDefaultExpansionContractionAnimationDuration 0.4
#define kFlickSpeedThreshold 1000

// The amount of pixels the tray can be pulled past its maximum extension so it can create a bounce effect.
#define kDefaultBouncePadding 30

@interface KITTrayView ()

typedef enum
{
    TrayViewDirectionUnknown,
    TrayViewDirectionLeft,
    TrayViewDirectionRight,
    TrayViewDirectionUp,
    TrayViewDirectionDown
} TrayViewDirection;


@property (assign, nonatomic) BOOL isTrayExpanded;
@property (assign, nonatomic) BOOL isCurrentlyDraggingTab;
@property (assign, nonatomic, readonly) TrayViewDirection expansionDirection;
@property (assign, nonatomic) TrayViewDirection lastRegisteredMovementDirection;
@property (assign, nonatomic) CGRect expandedViewFrame;
@property (assign, nonatomic) CGRect initialViewFrame;
@property (assign, nonatomic) CGPoint lastTouchedPoint;
@property (assign, nonatomic) CGRect bounceFrame;

- (void)calculateInitialAndExpandedViewFrames;

- (TrayViewDirection)calculateExpansionDirection;
- (CGRect)calculateExpandedRectangleWithExpansionDirection:(TrayViewDirection)direction;

@end

NSString *const kNotificationTrayViewDidStartContracting    = @"TrayViewDidStartContracting";
NSString *const kNotificationTrayViewDidFinishContracting   = @"TrayViewDidFinishContracting";
NSString *const kNotificationTrayViewDidStartExpanding      = @"TrayViewDidStartExpanding";
NSString *const kNotificationTrayViewDidFinishExpanding     = @"TrayViewDidFinishExpanding";
NSString *const kNotificationTrayViewDidStartDragging       = @"TrayViewDidStartDragging";
NSString *const kNotificationTrayViewDidFinishDragging      = @"TrayViewDidFinishDragging";

@implementation KITTrayView

- (void)commonInit
{
    _isTrayExpanded = NO;
    _bounces = YES;
    _contractionAnimationDuration   = kDefaultExpansionContractionAnimationDuration;
    _expansionAnimationDuration     = kDefaultExpansionContractionAnimationDuration;
    _bouncePadding = kDefaultBouncePadding ;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(trayTabDragged:)];
    [self.trayTabView addGestureRecognizer:panGestureRecognizer];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trayTabTapped:)];
    [self.trayTabView addGestureRecognizer:tapGestureRecognizer];
    
    if (self.trayTabView != self)
    {
        // Add an additional pan recognizer for the main view itself so the user can expand and contract without using the tab itself.
        UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(trayTabDragged:)];
        [self addGestureRecognizer:panGestureRecognizer2];
    }
}

- (void)calculateInitialAndExpandedViewFrames
{
    NSAssert(self.superview != nil, @"Superview needed to calculate expansion directions");
    NSAssert(_expansionDirection == TrayViewDirectionUnknown, @"This method should only be called once on initialization of the view.");

    _initialViewFrame   = self.frame;
    _expansionDirection = [self calculateExpansionDirection];
    _expandedViewFrame  = [self calculateExpandedRectangleWithExpansionDirection:_expansionDirection];
    _bounceFrame        = [self calculateBounceFrame];
}

/*!
@abstract
Calculates the expansionDirection property based on the current position of this view within it's superview.
The expansion direction will be the opposite of the side sticking furthest out from the superview.
*/
- (TrayViewDirection)calculateExpansionDirection
{
    CGRect superViewBounds = self.superview.bounds;
    float rightEdge     = self.frame.origin.x + self.frame.size.width;
    float bottomEdge    = self.frame.origin.y + self.frame.size.height;

    // Calculate the amount each edge is outside the bounds of the superview
    float widthOutsideRightEdgeOfSuperviewBounds    = rightEdge - superViewBounds.size.width;
    float widthOutsideLeftEdgeOfSuperviewBounds     = MIN(-self.frame.origin.x, self.frame.size.width);
    float heightOutsideTopEdgeOfSuperviewBounds     = MIN(-self.frame.origin.y, self.frame.size.height);
    float heightOutsideBottomEdgeOfSuperviewBounds  = bottomEdge - superViewBounds.size.height;

    // Based on the amount of the view that sticks outside the bounds of the superview, choose the side that sticks out the most as a candidate.
    // One candidate for vertical and one for horizontal
    TrayViewDirection horizontalExpansionDirectionCandidate =
            widthOutsideLeftEdgeOfSuperviewBounds <= widthOutsideRightEdgeOfSuperviewBounds   ? TrayViewDirectionLeft : TrayViewDirectionRight;
    TrayViewDirection verticalExpansionDirectionCandidate   =
            heightOutsideTopEdgeOfSuperviewBounds <= heightOutsideBottomEdgeOfSuperviewBounds ? TrayViewDirectionUp : TrayViewDirectionDown;
    float maxHorizontalOverflow = MAX(widthOutsideLeftEdgeOfSuperviewBounds, widthOutsideRightEdgeOfSuperviewBounds);
    float maxVerticalOverflow   = MAX(heightOutsideBottomEdgeOfSuperviewBounds, heightOutsideTopEdgeOfSuperviewBounds);

    // After the horizontal and vertical candidates are determined, do yet another comparison of the highest amount of
    // the view sticking out. If view was primarily above or below the superview the vertical candidate will be chosen, otherwise the horizontal candidate wins.
    TrayViewDirection finalExpansionDirection = maxHorizontalOverflow <= maxVerticalOverflow ? verticalExpansionDirectionCandidate : horizontalExpansionDirectionCandidate;

    return finalExpansionDirection;
}

- (CGRect)calculateExpandedRectangleWithExpansionDirection:(TrayViewDirection)direction
{
    CGRect result = _initialViewFrame;
    CGRect superviewBounds = self.superview.bounds;

    switch (direction)
    {
        case TrayViewDirectionUnknown:
            break;
        case TrayViewDirectionLeft:
            result.origin.x = superviewBounds.size.width - result.size.width;
            break;
        case TrayViewDirectionRight:
            result.origin.x = 0;
            break;
        case TrayViewDirectionUp:
            result.origin.y = superviewBounds.size.height - result.size.height;
            break;
        case TrayViewDirectionDown:
            result.origin.y = 0;
            break;
    }

    return result;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
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

#pragma mark - Event handlers

- (void)trayTabTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.isTrayExpanded)
    {
        [self contractTray];
    }
    else
    {
        [self expandTray];
    }
}

- (BOOL)isDirectionVertical:(TrayViewDirection)direction
{
    return direction == TrayViewDirectionDown || direction == TrayViewDirectionUp;
}

- (void)trayTabDragged:(UIPanGestureRecognizer*) recognizer
{
    BOOL draggingStopped = recognizer.state == UIGestureRecognizerStateEnded ||
                           recognizer.state == UIGestureRecognizerStateCancelled;
    if (draggingStopped)
    {
        CGPoint velocity = [recognizer velocityInView:self.superview];

        CGFloat flickSpeed = 0.0f;
        if ([self isDirectionVertical:self.expansionDirection])
        {
            flickSpeed = velocity.y;
        }
        else
        {
            flickSpeed = velocity.x;
        }

        BOOL shouldFlick = abs((int)flickSpeed) > kFlickSpeedThreshold;
        if (shouldFlick)
        {
            [self flickTrayWithSpeed:flickSpeed];
        }
        else
        {
            [self expandOrContractDependingDirection:self.lastRegisteredMovementDirection];
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidFinishDragging object:self];
        self.isCurrentlyDraggingTab = NO;
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Store where tap began
        self.lastTouchedPoint = [recognizer locationInView:self.superview];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidStartDragging object:self];
    }
    else
    {
        self.isCurrentlyDraggingTab = YES;
        CGPoint newPos = [recognizer locationInView:self.superview];
        
        BOOL verticalExpansion = [self isDirectionVertical:self.expansionDirection];
        
        CGFloat deltaMovement = verticalExpansion ?
            newPos.y - self.lastTouchedPoint.y :
            newPos.x - self.lastTouchedPoint.x;

        [self moveTrayWithDeltaMovement:deltaMovement];
        
        self.lastTouchedPoint = newPos;
        
        TrayViewDirection currentMovementDirection = [self movementDirectionFromDeltaMovement:deltaMovement];
        if (currentMovementDirection != TrayViewDirectionUnknown)
        {
            self.lastRegisteredMovementDirection = currentMovementDirection;
        }
    }
}

- (void)expandOrContractDependingDirection:(TrayViewDirection)direction
{
    
    // Fake a negative or positive speed based on the given direction
    CGFloat speed = (direction == TrayViewDirectionDown || direction == TrayViewDirectionRight) ? 1 : -1;
    
    // Use that speed to simulate a flick:
    [self flickTrayWithSpeed:speed];
}

- (void)flickTrayWithSpeed:(CGFloat)speed
{
    BOOL shouldContract =
            (self.expansionDirection == TrayViewDirectionDown && speed < 0) || // Contracting when flicking up if expansion is down
            (self.expansionDirection == TrayViewDirectionUp && speed > 0)   || // Contracting when flicking down if expansion is up
            (self.expansionDirection == TrayViewDirectionLeft && speed > 0) || // Contracting when flicking right if expansion is left
            (self.expansionDirection == TrayViewDirectionRight && speed < 0);  // Contracting when flicking left if expansion is right

    if (shouldContract)
    {
        [self contractTray];
    }
    else
    {
        [self expandTray];
    }
}

#pragma  mark - Tray movement

- (TrayViewDirection)movementDirectionFromDeltaMovement:(CGFloat)deltaMovement
{
    BOOL isVerticalMovement = [self isDirectionVertical:self.expansionDirection];
    TrayViewDirection movementDirection = TrayViewDirectionUnknown;
    if (isVerticalMovement && deltaMovement > 0)
    {
        movementDirection = TrayViewDirectionDown;
    }
    else if (isVerticalMovement && deltaMovement < 0)
    {
        movementDirection = TrayViewDirectionUp;
    }
    else if (!isVerticalMovement && deltaMovement < 0)
    {
        movementDirection = TrayViewDirectionLeft;
    }
    else if (!isVerticalMovement && deltaMovement > 0)
    {
        movementDirection = TrayViewDirectionRight;
    }

    return movementDirection;
}

// Returns a slightly bigger frame based on the expandedViewFrame.
// The frame is expanded to extend in the same direction as the expansion direction
// The end result is that the tray will bounce back a bit after being released by the user.
// This creates the classic bounceback effect that is on the table views.
- (CGRect)calculateBounceFrame
{
    CGRect expandedViewFrameCopy = self.expandedViewFrame;

    switch (self.expansionDirection)
    {
        case TrayViewDirectionUnknown:
            break;
        case TrayViewDirectionLeft:
            expandedViewFrameCopy.origin.x   -= self.bouncePadding;
            expandedViewFrameCopy.size.width += self.bouncePadding;
            break;
        case TrayViewDirectionRight:
            expandedViewFrameCopy.origin.x   += self.bouncePadding;
            expandedViewFrameCopy.size.width -= self.bouncePadding;
            break;
        case TrayViewDirectionUp:
            expandedViewFrameCopy.origin.y    -= self.bouncePadding;
            expandedViewFrameCopy.size.height += self.bouncePadding;
            break;
        case TrayViewDirectionDown:
            expandedViewFrameCopy.origin.y    += self.bouncePadding;
            expandedViewFrameCopy.size.height -= self.bouncePadding;
            break;
    }

    return expandedViewFrameCopy;
}

- (void)moveTrayWithDeltaMovement:(CGFloat)deltaMovement
{
    TrayViewDirection movementDirection = [self movementDirectionFromDeltaMovement:deltaMovement];

    CGRect movedFrame = self.frame;

    // Perform the movement
    switch (movementDirection)
    {
        case TrayViewDirectionUnknown:
            break;
        case TrayViewDirectionLeft:
        case TrayViewDirectionRight:
            movedFrame.origin.x += deltaMovement;
            break;
        case TrayViewDirectionUp:
        case TrayViewDirectionDown:
            movedFrame.origin.y += deltaMovement;
            break;
    }

    CGRect superviewFrame = self.superview.frame;
    CGRect tabFrame       = self.trayTabView.frame;
    CGRect modifiedExpandedViewFrame = self.bounces ? self.bounceFrame : self.expandedViewFrame;
    
    BOOL expandingRight = self.expansionDirection == TrayViewDirectionRight;
    BOOL expandingDown  = self.expansionDirection == TrayViewDirectionDown;

    // Cap the movement 
    switch (movementDirection)
    {

        case TrayViewDirectionUnknown:
            break;
        case TrayViewDirectionLeft:
            movedFrame.origin.x = expandingRight ?
            MAX(-movedFrame.size.width , movedFrame.origin.x) : // When moving left here we are closing the tray.
            MAX(superviewFrame.size.width - modifiedExpandedViewFrame.size.width, movedFrame.origin.x); // When moving left here we are opening the tray.
            break;
        case TrayViewDirectionRight:
            movedFrame.origin.x = expandingRight ?
            MIN(modifiedExpandedViewFrame.origin.x, movedFrame.origin.x) : // When moving right here we are opening the tray.
            MIN(modifiedExpandedViewFrame.origin.x + modifiedExpandedViewFrame.size.width - tabFrame.size.width, movedFrame.origin.x); // When moving right here we are closing the tray.
            break;
        case TrayViewDirectionUp:
            movedFrame.origin.y = expandingDown ?
            MAX(-movedFrame.size.height + self.trayTabView.frame.size.height, movedFrame.origin.y) :        // When moving UP here we are CLOSING the tray.
            MAX(superviewFrame.size.height - modifiedExpandedViewFrame.size.height, movedFrame.origin.y);   // When moving UP here we are OPENING the tray.
            break;
        case TrayViewDirectionDown:
            movedFrame.origin.y = expandingDown ?
            MIN(modifiedExpandedViewFrame.origin.y, movedFrame.origin.y) : // When moving DOWN here we are OPENING the tray.
            MIN(modifiedExpandedViewFrame.origin.y + modifiedExpandedViewFrame.size.height - tabFrame.size.height, movedFrame.origin.y); // When moving DOWN here we are CLOSING the tray.
            break;
    }

    // Apply the movement
    self.frame = movedFrame;
}

- (void)expandTray
{
    if (_expansionDirection == TrayViewDirectionUnknown)
    {
        return;
    }
    
    // Notify delegate that the tray will start expanding
    if (self.isTrayExpanded == NO)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidStartExpanding object:self];
    }
    
    // Shorter animation time if tray is already expanded.
    // This will kick in sometimes when the animation bounces.
    NSTimeInterval animationDuration = self.isTrayExpanded ? self.expansionAnimationDuration / 2 : self.expansionAnimationDuration;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
    {
        self.frame = self.expandedViewFrame;
    }
    completion:^(BOOL finished)
    {
        BOOL trayStatusWillChange = self.isTrayExpanded == NO;
        if (trayStatusWillChange)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidFinishExpanding object:self];
        }
        
        self.isTrayExpanded = YES;
    }];
}

- (void)contractTray
{
    if (_expansionDirection == TrayViewDirectionUnknown)
    {
        return;
    }
    
    // Notify delegate that the tray will start contracting
    if (self.isTrayExpanded == YES)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidStartContracting object:self];
    }
    
    
    [UIView animateWithDuration:self.expansionAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
    {
        self.frame = self.initialViewFrame;
    }
    completion:^(BOOL finished)
    {
        self.isTrayExpanded = NO;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTrayViewDidFinishContracting object:self];
    }];
}

#pragma mark - Properties

- (UIView*)trayTabView
{
    if (_trayTabView == nil)
    {
        _trayTabView = [self.subviews lastObject];
        if (_trayTabView == nil)
        {
            _trayTabView = self;
        }
    }
    
    return _trayTabView;
}

#pragma mark - UIView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil)
    {
        // Support for the tab being outside the bounds of the tray.
        if (CGRectContainsPoint(self.trayTabView.frame,point)) {
            view = self.trayTabView;
        }
    }
    
    return view;
}

- (void)layoutSubviews
{
    if (_expansionDirection == TrayViewDirectionUnknown)
    {
        [self calculateInitialAndExpandedViewFrames];
    }
    
    [super layoutSubviews];
}

@end
