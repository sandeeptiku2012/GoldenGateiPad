//
//  ShowSummaryCellPagedViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "GridViewController.h"

@class Show;
@interface ShowSummaryCellPaged :UITableViewCell<LoadingViewDelegate, GridViewControllerDelegate>

@property (weak, nonatomic) Show *show;

@property (weak, nonatomic) UINavigationController *navController;

@end
