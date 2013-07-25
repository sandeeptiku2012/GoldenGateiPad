//
//  ChannelTableCell.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelTableCell.h"
#import "ChannelCellView.h"

@interface ChannelTableCell()

@property (strong, nonatomic) ChannelCellView *channelCellView;

@end

@implementation ChannelTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.channelCellView = [[ChannelCellView alloc]initWithCellSize:CellSizeTable];
        self.channelCellView.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.channelCellView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.channelCellView.highlighted = selected;
}

- (void)setChannel:(Channel *)channel
{
    _channel = channel;
    
    self.channelCellView.channel = channel;
}


@end
