//
//  ChannelTableCell.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Channel;

@interface ChannelTableCell : UITableViewCell

@property (weak, nonatomic) Channel *channel;

@end
