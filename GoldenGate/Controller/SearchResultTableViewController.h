//
//  SearchResultTableViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewController : UITableViewController

- (void)showLoadingIndicator;
- (void)showSearchResults;
- (void)showError;

@property (weak, nonatomic) UINavigationController *mainNavigationController;

@end
