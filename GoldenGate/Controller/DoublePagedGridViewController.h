//
//  DoublePagedGridViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 04.09.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseNavViewController.h"

#import "GridViewController.h"
#import "LoadingView.h"

@class CellViewFactory;
@class LoadingView;

/*!
 @abstract
 This view controller is the base for all view controllers that show two vertically stacked paged grids.
 Override this class to set up what data you want to show in the grids, and how to show them.
 */
@interface DoublePagedGridViewController : BaseNavViewController <GridViewControllerDelegate, LoadingViewDelegate>

typedef enum
{
    GridPositionTop,
    GridPositionBottom
} GridPosition;


/*!
 @abstract
 @param name            This name will be displayed in a label above the grid.
 @param dataSource      The datasource for the data to be displayed in the grid.
 @param cellViewFactory The factory that will create the cells for the objects fetched from dataSource
 @param gridPosition    target grid.
 */
- (void)registerName:(NSString *)name
          dataSource:(PrefetchingDataSource*)dataSource
     cellViewFactory:(CellViewFactory *)cellViewFactory
   forGridAtPosition:(GridPosition)gridPosition;

/*!
 @abstract
 Reloads the grid at the given position. Also manages the showing and 
 hiding of loading indicators, loading text and the retry button.
 @param gridPosition the grid to reload
 */
- (void)reloadGridAtPosition:(GridPosition)gridPosition;

/*!
 @abstract 
 Convenience method for reloading the data in all the grids.
 */
- (void)reloadAllGrids;


/*!
 @abstract
 This method will start a spinning loading indicator for the grid at the given position.
 @param message The message to be shown
 @param gridPosition target grid for the operation.
 @note Should only be called from within the class hierarchy of this class.
 */
- (void)showLoadingIndicatorWithMessage:(NSString*)message forGridAtPosition:(GridPosition)gridPosition;

/*!
 @abstract
 This method will hide any loading indicator for the grid at gridPosition.
 @note Should only be called from within the class hierarchy of this class.
 */
- (void)hideLoadingIndicatorForGridAtPosition:(GridPosition)gridPosition;

/*!
 @abstract
 This method will show a retry button that will prompt a reload of the table.
 @param message The message to be shown
 @param gridPosition target grid for the operation.
 @note Should only be called from within the class hierarchy of this class.
 */
- (void)showRetryWithMessage:(NSString *)message forGridAtPosition:(GridPosition)gridPosition;


/*!
 @abstract
 Shows a message in a text label in the middle of the grid and nothing else.
 @param message Message to be shown.
 @param gridPosition target grid for the operation.
 */
- (void)showMessage:(NSString *)message forGridAtGridPosition:(GridPosition)gridPosition;


@end
