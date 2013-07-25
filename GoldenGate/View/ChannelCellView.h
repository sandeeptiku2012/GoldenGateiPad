//
//  ChannelCellView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CellView.h"

@class Channel;

@interface ChannelCellView : CellView

- (id)initWithCellSize:(CellSize)size;

@property (strong, nonatomic) Channel *channel;

@end
