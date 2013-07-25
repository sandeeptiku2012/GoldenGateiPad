//
//  GGAppearanceManager.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/28/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGAppearanceManager.h"
#import "GGLabelStylizer.h"

@implementation GGAppearanceManager


+ (void)configureNavBarAppearance
{
    [[UINavigationBar appearance] setTitleTextAttributes:[GGLabelStylizer textPropertyDictWithFontSize:24]];
    
    [[UINavigationBar appearance]setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"NavBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil]setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"BackButtonBg.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[GGLabelStylizer textPropertyDictWithFontSize:[GGLabelStylizer barButtonTitleFontSize]] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(3, 1) forBarMetrics:UIBarMetricsDefault];
}

// Put any global appearance configurations here!
+ (void)configureAppearance
{
    [self configureNavBarAppearance];
}

@end
