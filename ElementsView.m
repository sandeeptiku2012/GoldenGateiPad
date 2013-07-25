//
//  ElementsView.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 25/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ElementsView.h"
#import "CAAnimation+Blocks.h"

#define REMOVE_SUBELEMENTSVIEW @"RemSubElements"

@interface ElementsView ()


@end

@implementation ElementsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)init{
    if (self = [super init]) {
        [self initFromNibCustom];
    }
    
    return self;
}


-(void)initFromNibCustom
{
    self.viewWithElements = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    self.viewWithElements.userInteractionEnabled = YES;
    [self setElementsViewAttributes];
    [self.backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,0)];
    [self addSubview:self.viewWithElements];
}


-(void)hideBackButton:(BOOL)bHide
{
    if (bHide) {
        self.backButton.hidden=YES;
    }else{
        self.backButton.hidden=NO;
    }
    
}

-(void) setElementsViewAttributes{
    
    self.viewWithElements.layer.cornerRadius = 5;     
    
    self.backgroundColor = [UIColor clearColor];
}




- (IBAction) backClicked: (id) sender
{
    NSLog(@"backClicked");    
    if ([self.delegate respondsToSelector:@selector(backButtonTapped)]) {
        [self.delegate backButtonTapped];
    }
    [self setAlpha:0.0];
	// set up an animation for the transition between the views
	CATransition *animation = [self getPushRightAnimation];
	[[self layer] addAnimation:animation forKey:REMOVE_SUBELEMENTSVIEW];
    [UIView commitAnimations];    
}


-(CATransition*)getPushRightAnimation
{
    CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
    [animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return animation;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
    if (flag) {      
                      
        [self removeFromSuperview];
    }
}



-(void) showRelatedContentView
{
    [self.relatedContentView setHidden:NO];
    [self.relatedContentViewImage setHidden:NO];
    [self.relatedContentViewLabel setHidden:NO];
    [self.relatedContentView setUserInteractionEnabled:YES];
    
}


-(void) hideRelatedContentView
{
    [self.relatedContentView setHidden:YES];
    [self.relatedContentViewLabel setHidden:YES];
    [self.relatedContentViewImage setHidden:YES];
    [self.relatedContentView setUserInteractionEnabled:NO];
    
}


-(void) hideTheViewWithElements
{
    self.viewWithElements.hidden = YES;
    
}

-(void) showTheViewWithElements
{
    
    self.viewWithElements.hidden = NO;
}








@end
