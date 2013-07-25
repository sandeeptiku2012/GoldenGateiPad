//
//  RMGridLayoutView.h
//  Reaktor
//
//  Created by Andreas Petrov on 11/25/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @abstract This view automatically lays out it´s subviews in a grid.
 */
@interface KITGridLayoutView : UIView


/*!
 @abstract The distance from the top of the view to the first row of gridded subviews.
 */
@property (assign, nonatomic) CGFloat topMargin;

/*!
 @abstract The distance from the left of the view to the first row of gridded subviews.
 */
@property (assign, nonatomic) CGFloat leftMargin;

/*!
 @abstract The horizontal distance between gridded subviews.
 */
@property (assign, nonatomic) CGFloat horizontalGridSpacing;

/*!
 @abstract The vertical distance between gridded subviews.
 */
@property (assign, nonatomic) CGFloat verticalGridSpacing;

/*!
 @abstract When YES layoutSubviews will animate any layout changes.
 */
@property (assign, nonatomic) BOOL animateLayout;


/*!
 @abstract When YES items that go outside the right side of the view will be put on the next row.
 @note 
 Default is YES.
 */
@property (assign, nonatomic) BOOL autoWrap;


/*!
 @abstract When YES the view itself will expand vertically to fit its children.
 @note
 Default is NO.
 */
@property (assign, nonatomic) BOOL autoResizeHorizontally;


/*!
//Function to get grid height if filled with cells of equal size
 */
-(float)getGridHeightForEqualSizeCell:(CGSize)sizeCell numcells:(int)numCells;



@end
