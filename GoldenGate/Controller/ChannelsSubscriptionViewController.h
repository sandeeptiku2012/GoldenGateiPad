//
//  ChannelsSubscriptionViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 13/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "BaseNavViewController.h"
#import "LoadingView.h"

//Controller to show Subscribed channels grouped gy Genre

@class ContentCategory;

@interface ChannelsSubscriptionViewController : BaseNavViewController<UITableViewDataSource, UITableViewDelegate, LoadingViewDelegate>

// Parent navigation controller. This can be explicitly assigned by containing controller if
// the containing controller is on navigation stack
@property(weak, nonatomic)UINavigationController* custParentNavigationController;

// initialize controller with category. Useful when view of controller used
// rather than pushing controller on navigation stack
-(id)initWithCategory:(ContentCategory*)category;


@end
