//
//  LoadingTableCell.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoadingView.h"

@interface LoadingTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end
