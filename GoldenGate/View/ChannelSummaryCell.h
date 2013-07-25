//
//  ChannelSummaryCell.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/27/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Channel;
@class VideoCache;

@interface ChannelSummaryCell : UITableViewCell

@property (weak, nonatomic) Channel *channel;

@property (weak, nonatomic) UINavigationController *navController;

@property (weak, nonatomic) VideoCache *videoCache;

- (void)hideAllVideoCells;

@end
