//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GMGridView.h"
#import "PrefetchingDataSource.h"

@class CellViewFactory;
@class GridViewController;
@class GridCellWrapper;

@protocol GridViewControllerDelegate <NSObject>

@required
- (void)gridViewController:(GridViewController*)gridViewController didTapCell:(GridCellWrapper*)gridCell;

@optional
- (void)gridViewController:(GridViewController*)gridViewController processDeletionOfObject:(NSObject*)object;
- (void)gridViewController:(GridViewController *)gridViewController currentPageChanged:(NSUInteger)currentPage pageCount:(NSUInteger)pageCount;
- (void)gridViewController:(GridViewController *)gridViewController changedEdit:(BOOL)edit;

@end

@interface GridViewController : NSObject <GMGridViewDataSource, GMGridViewActionDelegate, UIScrollViewAccessibilityDelegate>

@property (strong, nonatomic) CellViewFactory *gridCellFactory;
@property (strong, nonatomic) GMGridView *gridView;
@property (strong, nonatomic) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) id<GridViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL enableEditing;

/*!
 @abstract
 If YES a call to reloadData will clear any cached data in the datasource
 @note
 Default is YES.
 */
@property (assign, nonatomic) BOOL clearsDataSourceOnReload;

- (id)initWithGridView:(GMGridView *)gridView gridCellFactory:(CellViewFactory *)gridCellFactory dataSource:(PrefetchingDataSource *)dataSource;


/*!
 @abstract tells the data source to figure out how many items it has in total before making the grid view reload.
 */
- (void)reloadData;


/*!
 @abstract Same as reloadData but with success and error handlers that are called after the data has finished loading.
 */
- (void)reloadData:(VoidHandler)onSuccess errorHandler:(ErrorHandler)onError;

/*!
 @abstract
 Will clear the datasource.
 */
- (void)clearData;

@end