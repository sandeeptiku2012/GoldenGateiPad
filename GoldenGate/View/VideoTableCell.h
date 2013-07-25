//
//  VideoTableCell.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Video;

@interface VideoTableCell : UITableViewCell

@property (weak, nonatomic) Video *video;

@end
