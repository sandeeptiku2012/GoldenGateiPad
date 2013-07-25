//
//  GridCellWrapper.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GMGridViewCell.h"

@class CellView;

/*!
 @abstract
 A wrapper class wrapping the CellView with a AQGridViewCell that can be used in AQGridView
 */
@interface GridCellWrapper : GMGridViewCell


@property (strong, nonatomic) CellView *cellView;

/*!
 @abstract stores the index this grid cell is currently inhabiting.
 */
@property (assign) NSInteger gridIndex;
@property (assign, nonatomic) NSObject *dataObject;


@end
