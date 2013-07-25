//
//  NavigationTableViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/12/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryAction;
@class BaseNavViewController;


/*!
 @abstract
 This is the view controller for the table view that appears when the user 
 presses the navigation button found in the top left corner of the application.
 */
@interface NavigationTableViewController : UITableViewController

- (id)initWithMainViewController:(BaseNavViewController *)viewController;

/*!
 @abstract 
 The NavAction the table currently depicts.
 */
@property (strong, nonatomic) CategoryAction *navAction;


/*!
 @abstract
 Additional NavigationTableViewControllers will be pushed onto the 
 UIPopover's UINavigationController until self.navAction.subActions contains targetAction
 */
@property (strong, nonatomic) CategoryAction *targetAction;

@end
