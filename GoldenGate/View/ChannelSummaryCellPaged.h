//
//  ChannelSummaryCellPaged.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 09/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "GridViewController.h"

@class Channel;

//Table view Cell to show Channel and Videos

@interface ChannelSummaryCellPaged  : UITableViewCell<LoadingViewDelegate, GridViewControllerDelegate>

@property (weak, nonatomic) Channel *channel;

@property (weak, nonatomic) UINavigationController *navController;

@end
