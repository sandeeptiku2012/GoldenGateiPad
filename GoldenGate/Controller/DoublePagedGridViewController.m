//
//  DoublePagedGridViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 04.09.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "DoublePagedGridViewController.h"
#import "GridCellWrapper.h"
#import "Video.h"
#import "Channel.h"
#import "GMGridViewLayoutStrategies.h"
#import "CellViewFactory.h"
#import "ChannelModalViewController.h"

#import "VideoPlaybackViewController.h"
#import "PageIndicatorView.h"

#define kLabelPadding 10

@interface DoublePagedGridViewController ()

@property (weak, nonatomic) IBOutlet GMGridView *topGrid;
@property (weak, nonatomic) IBOutlet GMGridView *bottomGrid;

@property (strong, nonatomic) GridViewController *topGridController;
@property (strong, nonatomic) GridViewController *bottomGridController;

@property (weak, nonatomic) IBOutlet PageIndicatorView *topPageIndicator;
@property (weak, nonatomic) IBOutlet PageIndicatorView *bottomPageIndicator;

@property (weak, nonatomic) IBOutlet UILabel *topGridLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomGridLabel;

@property (strong, nonatomic) NSString *topLabelText;
@property (strong, nonatomic) NSString *bottomLabelText;

@property (weak, nonatomic) IBOutlet LoadingView *topLoadingView;
@property (weak, nonatomic) IBOutlet LoadingView *bottomLoadingView;

@end

@implementation DoublePagedGridViewController

- (id)init
{
    if ((self = [super initWithNibName:@"DoublePagedGridViewController" bundle:nil]))
    {
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupGrid:self.topGrid];
    [self setupGrid:self.bottomGrid];

    self.topGridLabel.text      = self.topLabelText;
    self.bottomGridLabel.text   = self.bottomLabelText;

    self.topGridController.gridView  = self.topGrid;
    self.bottomGridController.gridView    = self.bottomGrid;

    if (self.shouldReloadGridsOnViewDidLoad)
    {
        [self reloadAllGrids];
    }
}

- (BOOL)shouldReloadGridsOnViewDidLoad
{
    return YES;
}

- (void)setupGrid:(GMGridView *)grid
{
    grid.layoutStrategy                      = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    grid.horizontalItemSpacing               = kHorizontalGridSpacing;
    grid.verticalItemSpacing                 = kVerticalGridSpacing;
    grid.showsHorizontalScrollIndicator      = NO;
}

- (void)reloadGridAtPosition:(GridPosition)gridPosition
{
    GridViewController *gridViewControllerForPosition = [self gridViewControllerForGridAtPosition:gridPosition];
    PageIndicatorView *pageIndicatorView = [self pageIndicatorForGridAtPosition:gridPosition];
    pageIndicatorView.hidden = YES;
    
    [self showLoadingIndicatorWithMessage:[self loadingMessageForGridAtPosition:gridPosition] forGridAtPosition:gridPosition];
    [gridViewControllerForPosition reloadData:^
    {
        if (gridViewControllerForPosition.dataSource.cachedTotalItemCount > 0)
        {
            pageIndicatorView.hidden = [self shouldHidePageIndicatorForGridAtPosition:gridPosition];
            [self hideLoadingIndicatorForGridAtPosition:gridPosition];
        }
        else
        {
            pageIndicatorView.hidden = YES;
            [self showMessage:[self noContentStringForGridAtPosition:gridPosition] forGridAtGridPosition:gridPosition];
        }
    }
    errorHandler:^(NSError *error)
    {
        pageIndicatorView.hidden = NO;
        [self showRetryWithMessage:[self contentLoadErrorStringForGridAtPosition:gridPosition] forGridAtPosition:gridPosition];
    }];
}

- (BOOL)shouldHidePageIndicatorForGridAtPosition:(GridPosition)position
{
    return NO;
}

- (NSString *)loadingMessageForGridAtPosition:(GridPosition)position
{
    return NSLocalizedString(@"LoadingContentLKey", @"");
}

- (void)reloadAllGrids
{
    [self reloadGridAtPosition:GridPositionTop];
    [self reloadGridAtPosition:GridPositionBottom];
}

- (LoadingView *)loadingViewForGridPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? self.topLoadingView : self.bottomLoadingView;
}

- (void)showLoadingIndicatorWithMessage:(NSString *)message forGridAtPosition:(GridPosition)gridPosition
{
    GridViewController *gridViewController = [self gridViewControllerForGridAtPosition:gridPosition];
    gridViewController.gridView.hidden = YES;
    [[self loadingViewForGridPosition:gridPosition] startLoadingWithText:message];
}

- (void)hideLoadingIndicatorForGridAtPosition:(GridPosition)gridPosition
{
    GridViewController *gridViewController = [self gridViewControllerForGridAtPosition:gridPosition];
    gridViewController.gridView.hidden = NO;
    [[self loadingViewForGridPosition:gridPosition] endLoading];
}

- (void)showRetryWithMessage:(NSString *)message forGridAtPosition:(GridPosition)gridPosition
{
    GridViewController *gridViewController = [self gridViewControllerForGridAtPosition:gridPosition];
    gridViewController.gridView.hidden = YES;
    [[self loadingViewForGridPosition:gridPosition] showRetryWithMessage:message];
}

- (void)showMessage:(NSString *)message forGridAtGridPosition:(GridPosition)gridPosition
{
    GridViewController *gridViewController = [self gridViewControllerForGridAtPosition:gridPosition];
    gridViewController.gridView.hidden = YES;
    [[self loadingViewForGridPosition:gridPosition] showMessage:message];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.topGridController clearData];
    [self.bottomGridController clearData];
}

- (NSString*)noContentStringForGridAtPosition:(GridPosition)gridPosition
{
    return @"";
}

- (NSString *)contentLoadErrorStringForGridAtPosition:(GridPosition)gridPosition
{
    return @"";
}

#pragma mark - GridViewControllerDelegate

- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    NSObject*dataObject = gridCell.dataObject;
    if ([dataObject isKindOfClass:[Channel class]])
    {
        [ChannelModalViewController showFromView:gridCell.cellView
                                    withChannel:(Channel*)dataObject
                                  navController:self.navigationController];
    }
    else if ([dataObject isKindOfClass:[Video class]])
    {
        [VideoPlaybackViewController presentVideo:(Video*)dataObject fromChannel:nil withNavigationController:self.navigationController];
    }
}

- (void)gridViewController:(GridViewController *)gridViewController
        currentPageChanged:(NSUInteger)currentPage
                 pageCount:(NSUInteger)pageCount
{
    if (gridViewController == self.topGridController)
    {
        self.topPageIndicator.currentPage  = currentPage;
        self.topPageIndicator.pageCount    = pageCount;
    }
    else if (gridViewController == self.bottomGridController)
    {
        self.bottomPageIndicator.currentPage    = currentPage;
        self.bottomPageIndicator.pageCount      = pageCount;
    }
}

- (GridViewController*)gridViewControllerForGridAtPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? self.topGridController : self.bottomGridController;
}

- (PageIndicatorView*)pageIndicatorForGridAtPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? self.topPageIndicator : self.bottomPageIndicator;
}

- (void)registerName:(NSString *)name
          dataSource:(PrefetchingDataSource*)dataSource
     cellViewFactory:(CellViewFactory *)cellViewFactory
   forGridAtPosition:(GridPosition)gridPosition
{
    NSAssert(!self.isViewLoaded, @"This method should be called before view is loaded.");
    
    GridViewController *gridViewControllerForPosition = [self gridViewControllerForGridAtPosition:gridPosition];
    gridViewControllerForPosition.dataSource = dataSource;
    gridViewControllerForPosition.gridCellFactory = cellViewFactory;
    
    if (gridPosition == GridPositionTop)
    {
        self.topLabelText = name;
    }
    else
    {
        self.bottomLabelText = name;
    }
}

#pragma mark - Properties

- (GridViewController *)bottomGridController
{
    if (_bottomGridController == nil)
    {
        _bottomGridController = [self createGridViewController];
    }

    return _bottomGridController;
}


- (GridViewController *)topGridController
{
    if (_topGridController == nil)
    {
        _topGridController = [self createGridViewController];
    }

    return _topGridController;
}

- (GridViewController *)createGridViewController
{
    GridViewController *viewController = [GridViewController new];
    viewController.delegate = self;
    return viewController;
}

- (void)layoutPageIndicators
{
    [self.topGridLabel sizeToFit];
    [self.bottomGridLabel sizeToFit];
    
    CGRect topIndicatorFrame            = self.topPageIndicator.frame;
    topIndicatorFrame.origin.x          = self.topGridLabel.frame.origin.x + self.topGridLabel.frame.size.width + kLabelPadding;
    self.topPageIndicator.frame         = topIndicatorFrame;
    
    CGRect bottomIndicatorFrame         = self.bottomPageIndicator.frame;
    bottomIndicatorFrame.origin.x       = self.bottomGridLabel.frame.origin.x + self.bottomGridLabel.frame.size.width + kLabelPadding;
    self.bottomPageIndicator.frame      = bottomIndicatorFrame;
}

- (void)viewDidLayoutSubviews
{
    [self layoutPageIndicators];
}

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self retryButtonPressedForGridAtPosition:loadingView == self.topLoadingView ? GridPositionTop : GridPositionBottom];
}

- (void)retryButtonPressedForGridAtPosition:(GridPosition)gridPosition
{
    // Default impl does nothing. Re-implement in subclasses
}


@end
