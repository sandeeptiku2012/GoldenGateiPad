//
//  SingleGridViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "BaseNavViewController.h"
#import "GridViewController.h"
#import "LoadingView.h"

@class CellViewFactory;
@class PrefetchingDataSource;

@interface SingleGridViewController : BaseNavViewController <GridViewControllerDelegate, LoadingViewDelegate>

- (void)registerName:(NSString *)name
          dataSource:(PrefetchingDataSource*)dataSource
     cellViewFactory:(CellViewFactory *)cellViewFactory
       enableEditing:(BOOL)enableEditing;


@property (copy, nonatomic) NSString *headerLabelText;
@property (weak, nonatomic) IBOutlet GMGridView *gridView;
/*!
 @abstract
 Called when the datasource finishes loading its data.
 @note
 Override in subclasses. Do not call explicitly outside loadData
 */
- (void)dataDidFinishLoading;

/*!
 @abstract
 Override in subclasses to show a custom view when there is no content in the grid.
 @note
 Do not call explicitly outside viewDidLoad
 */
- (UIView*)createNoContentWarningView;

@property (strong, nonatomic, readonly) PrefetchingDataSource *dataSource;

@property (assign, nonatomic) BOOL showEditButton;


@end
