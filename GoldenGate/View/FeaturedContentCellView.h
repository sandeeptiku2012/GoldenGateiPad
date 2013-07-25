//
//  FeaturedChannelCellView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CellView.h"

@class FeaturedContent;

@interface FeaturedContentCellView : CellView

@property (weak, nonatomic) FeaturedContent *featuredContent;

- (id)initWithCellSize:(CellSize)size;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
