//
//  VideoTableCell.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VideoTableCell.h"

#import "VideoCellView.h"

@interface VideoTableCell()

@property (strong, nonatomic) VideoCellView *videoCellView;

@end

@implementation VideoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.videoCellView = [[VideoCellView alloc]initWithCellSize:CellSizeTable];
        self.videoCellView.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.videoCellView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.videoCellView.highlighted = selected;
}

- (void)setVideo:(Video *)video
{
    _video = video;
    
    self.videoCellView.video = video;
}

@end
