//
//  EpisodeCellView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 27/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "CellView.h"

@class Video;

@interface EpisodeCellView : CellView

@property (strong, nonatomic) Video *video;

- (id)initWithCellSize:(CellSize)size;

@property (assign, nonatomic) BOOL showFavoriteButton;
@property (assign, nonatomic) BOOL showShowTitleLabel;

@end
