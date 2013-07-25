//
//  CellViewFactory.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CellViewFactory.h"
#import "ChannelCellView.h"
#import "ShowCellView.h"

@implementation CellViewFactory

- (id)initWithWantedCellSize:(CellSize)wantedCellSize cellViewClass:(Class)cellViewClass
{
    if ((self = [super init]))
    {
        NSAssert([cellViewClass isSubclassOfClass:[CellView class]], @"cellViewClass must be subclass of CellView");

        _wantedCellSize = wantedCellSize;
        _cellViewClass = cellViewClass;
    }

    return self;
}

- (CellView *)createCellView
{
    CellView *cellView = [[self.cellViewClass alloc] initWithCellSize:self.wantedCellSize];
    return cellView;
}

@end
