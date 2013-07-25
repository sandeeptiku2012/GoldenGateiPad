//
//  TileView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIButton

typedef enum
{
    CellSizeSmall,
    CellSizeLarge,
    CellSizeLargeTextRight,
    CellSizeLargeTextBelow,
    CellSizeTable,
    CellSizeLong,
    CellSizeSquare
} CellSize;

/*!
 @note Call only from subclass initializers.
 */
- (id)initWithCellSize:(CellSize)size subclass:(Class)subclass;


@property (assign, nonatomic) CellSize cellSize;

/*!
 @abstract 
 Set to YES to animate the cell with a "bump" when setSelected is called.
 NO by default.
 */
@property (assign, nonatomic) BOOL animateSelection;


/*!
 @abstract
 Reimplemented by subclasses to change the data viewed in the CellView
 */
- (void)replaceDataObject:(NSObject*)dataObject;
- (NSObject*)fetchDataObject;

/*!
 @abstract
 Override in subclasses to setup the view so it looks better on light backgrounds
 */
- (void)styleForLightBackground;

@end
