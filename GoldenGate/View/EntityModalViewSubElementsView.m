//
//  EntityModalViewSubElementsView.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 12/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "EntityModalViewSubElementsView.h"
#import "CAAnimation+Blocks.h"


#define REMOVE_SUBELEMENTSVIEW @"RemSubElements"

@interface EntityModalViewSubElementsView()



@end

@implementation EntityModalViewSubElementsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    if (self = [super init]) {
        UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
        contentView.userInteractionEnabled = YES;
        
        if ((self = [self initWithFrame:contentView.frame]))
        {
            self.backgroundColor = [UIColor clearColor]; // Get rid of IB placeholder.
            [self addSubview:contentView];

        }
    }


    
    return self;
    
}


-(void)addBackButtonWithText:(NSString*)strBackString
{
    NSLog(@"addBackButtonWithText");
    
    
    
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: strBackString
                                   style: UIBarButtonItemStyleBordered
                                   target: self action: @selector (backClicked:)];
    
    UIImage* bgImage = [UIImage imageNamed:@"BackButtonBg.png"];
    UIFont* textFont = [UIFont boldSystemFontOfSize:12];
    [ backButton setBackgroundImage:bgImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont, UITextAttributeFont,nil] forState:UIControlStateNormal];
    [navItem setHidesBackButton:YES];
    [navItem setLeftBarButtonItem:backButton];
    UIOffset offsetTitle = [backButton titlePositionAdjustmentForBarMetrics:UIBarMetricsDefault];
    
    CGSize textSize = [strBackString sizeWithFont:textFont];
    CGSize sizeButtonBgImage = bgImage.size;
    float textWidth = (textSize.width+(2*offsetTitle.horizontal));
    float offsetWidth = textWidth+sizeButtonBgImage.width+10;
    
    
    CGRect rectLabel = self.navBarTitle.frame;
    rectLabel.origin.x = rectLabel.origin.x+ offsetWidth;
    [self.navBarTitle setFrame:rectLabel];
    [self.navBar pushNavigationItem:navItem animated:NO];
    
    
}

- (void) backClicked: (id) sender
{
    NSLog(@"backClicked");
    
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

@end
