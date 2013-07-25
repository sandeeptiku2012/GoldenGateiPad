//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "GridViewController.h"
#import "CellViewFactory.h"
#import "GridCellWrapper.h"



@interface GridViewController()

@property (strong, nonatomic) CellView *prototypeCell; // Used for size calculation.

@end

@implementation GridViewController
- (id)initWithGridView:(GMGridView *)gridView gridCellFactory:(CellViewFactory *)gridCellFactory dataSource:(PrefetchingDataSource *)dataSource
{
    if ((self = [super init]))
    {
        self.gridView = gridView;
        self.gridCellFactory = gridCellFactory;
        self.dataSource = dataSource;
        self.clearsDataSourceOnReload = YES;

    }

    return self;
}

- (void)reloadData
{
    [self reloadData:nil errorHandler:nil];
}

- (void)reloadData:(VoidHandler)onSuccess errorHandler:(ErrorHandler)onError
{
    if (self.clearsDataSourceOnReload)
    {
        [self clearData];
    }

    // Just kickstart the data source so it can know how many items it has in total.
    [self.dataSource fetchDataObjectAtIndex:0 successHandler:^(NSObject *dataObject)
    {
        if (onSuccess)
        {
            onSuccess();
        }
        
        [self.gridView reloadData];
        [self notifyCurrentPageChangedForScrollView:self.gridView];
    } errorHandler:onError];
}

- (void)clearData
{
    [self.dataSource resetDataSource];
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.dataSource.cachedTotalItemCount; 
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return self.prototypeCell.bounds.size;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
//    NSLog(@"TableView: %p -> Created cell for object at index: %d",gridView, index);

    GridCellWrapper *gridCellWrapper = (GridCellWrapper *) [self.gridView dequeueReusableCell];

    if (gridCellWrapper == nil)
    {
        gridCellWrapper = [[GridCellWrapper alloc] init];
        gridCellWrapper.cellView = [self.gridCellFactory createCellView];
    }
    
    //NSLog(@"Index created for %d:",index);
    gridCellWrapper.gridIndex = index;
    gridCellWrapper.dataObject = nil;
    
    [self.dataSource fetchDataObjectAtIndex:(NSUInteger)index
                             successHandler:^(NSObject *dataObject)
    {
        // Only replace the data object if the gridcell still has the same index as when the asynch fetchDataObjectAtIndex call was made.
        if (gridCellWrapper.gridIndex == index)
        {
            gridCellWrapper.dataObject = dataObject;
        }
    } errorHandler:nil];
    if(index==0)
        [gridCellWrapper setAccessibilityLabel:@"PopularVideo"];
    
    return gridCellWrapper;
}

#pragma mark - Properties

- (CellView *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [self.gridCellFactory createCellView];
    }
    
    return _prototypeCell;
}

- (void)setGridView:(GMGridView *)gridView
{
    gridView.actionDelegate = self;
    gridView.dataSource = self;
    gridView.delegate = self;
    _gridView = gridView;
}

#pragma mark - GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    [self.delegate gridViewController:self didTapCell:(GridCellWrapper*)[self.gridView cellForItemAtIndex:position]];
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(gridViewController:processDeletionOfObject:)])
    {
        [self.dataSource fetchDataObjectAtIndex:index successHandler:^(NSObject *dataObject)
        {
            [self.delegate gridViewController:self processDeletionOfObject:dataObject];
        } errorHandler:nil];
        
        [self.gridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    }
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return self.enableEditing;
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
    if ([self.delegate respondsToSelector:@selector(gridViewController:changedEdit:)])
    {
        [self.delegate gridViewController:self changedEdit:edit];
    }
}

#pragma mark - UIScrollViewDelegate

- (NSUInteger)currentPageForScrollView:(UIScrollView*)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    return floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (NSUInteger)pageCountForScrollView:(UIScrollView*)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    return scrollView.contentSize.width / pageWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self notifyCurrentPageChangedForScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self notifyCurrentPageChangedForScrollView:scrollView];
}

- (void)notifyCurrentPageChangedForScrollView:(UIScrollView *)scrollView
{
    if (self.gridView.isPagingEnabled)
    {
        if ([self.delegate respondsToSelector:@selector(gridViewController:currentPageChanged:pageCount:)])
        {
            NSUInteger currentPage  = [self currentPageForScrollView:scrollView];
            NSUInteger pageCount    = [self pageCountForScrollView:scrollView];
            [self.delegate gridViewController:self currentPageChanged:currentPage pageCount:pageCount];
        }
    }
}

@end