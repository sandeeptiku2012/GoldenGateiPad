//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class NavAction;


@interface NavActionExecutor : NSObject

/*!
 @abstract
 Clears the cache that stores view controllers that have been navigated to by the NavActionExecutor.
 Clearing the cache means that any page that is navigated to will be created anew and have it's data re-loaded.
 */
+ (void)clearViewControllerCache;

/*!
 @abstract
 Navigates the application to the given NavAction using the navigation controller of the given UIViewController.
 */
+ (void)executeNavAction:(NavAction *)action fromViewController:(UIViewController *)viewController;

@end