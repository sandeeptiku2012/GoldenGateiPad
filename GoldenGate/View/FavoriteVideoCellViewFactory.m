//
//  FavoriteVideoCellViewFactory.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoriteVideoCellViewFactory.h"

#import "VideoCellView.h"

@implementation FavoriteVideoCellViewFactory

- (id)init
{
    if ((self = [super initWithWantedCellSize:CellSizeLarge cellViewClass:[VideoCellView class]]))
    {
        
    }
    
    return self;
}

- (CellView *)createCellView
{
    VideoCellView *cellView = (VideoCellView *)[super createCellView];
    NSAssert([cellView isKindOfClass:[VideoCellView class]],@"cellView must be of class VideoCellView");
    cellView.showChannelTitleLabel = YES;
//    cellView.showFavoriteButton = YES;
//    cellView.userInteractionEnabled = NO;
    
    return cellView;
}

@end
