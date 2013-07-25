//
//  VideoTileView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CellView.h"

@class Video;

@interface VideoCellView : CellView

@property (strong, nonatomic) Video *video;

- (id)initWithCellSize:(CellSize)size;

@property (assign, nonatomic) BOOL showFavoriteButton;
@property (assign, nonatomic) BOOL showChannelTitleLabel;

@end
