//
//  ShowsSubscriptionsViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "BaseNavViewController.h"
#import "LoadingView.h"

@class ContentCategory;
@interface ShowsSubscriptionsViewController : BaseNavViewController <UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate>

// Parent navigation controller. This can be explicitly assigned by containing controller if
// the containing controller is on navigation stack
@property(weak, nonatomic)UINavigationController* custParentNavigationController;

// initialize controller with category. Useful when view of controller used
// rather than pushing controller on navigation stack
-(id)initWithCategory:(ContentCategory*)category;


@end
