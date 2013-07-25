//
//  ShowSubCellView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 12/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "CellView.h"

@class Show;

@interface ShowSubCellView : CellView

@property (strong, nonatomic) Show *show;

- (id)initWithCellSize:(CellSize)size;

@property (assign, nonatomic) BOOL showFavoriteButton;
@property (assign, nonatomic) BOOL showShowTitleLabel;
@end
