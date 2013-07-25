//
//  SingleGridViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SingleGridViewController.h"

#import "GridCellWrapper.h"
#import "Video.h"
#import "VideoPlaybackViewController.h"
#import "Constants.h"

@interface SingleGridViewController ()


@property (weak, nonatomic) IBOutlet UIButton   *editButton;
@property (weak, nonatomic) IBOutlet UILabel    *headerLabel;
@property (weak, nonatomic) IBOutlet UIView     *contentView;
@property (weak, nonatomic) IBOutlet LoadingView    *loadingView;
@property (weak, nonatomic) UIView         *noContentWarningView;

@property (strong, nonatomic, readwrite) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) GridViewController *gridViewController;

@end

@implementation SingleGridViewController

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNibName:@"SingleGridViewController" bundle:nil]))
    {
        self.navAction = navAction;
    }
    
    return self;
}


- (void)registerName:(NSString *)name
          dataSource:(PrefetchingDataSource*)dataSource
     cellViewFactory:(CellViewFactory *)cellViewFactory
      enableEditing:(BOOL)enableEditing
{
    self.dataSource = dataSource;
    self.gridViewController = [GridViewController new];
    self.gridViewController.enableEditing = enableEditing;
    self.gridViewController.dataSource = dataSource;
    self.gridViewController.gridCellFactory = cellViewFactory;
    self.gridViewController.delegate = self;
    self.headerLabelText = name;
}

- (void)setupGrid
{
    self.gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.gridView.clipsToBounds = YES;
    self.gridView.minimumPressDuration          = 1;
    self.gridView.centerGrid                    = NO;
    self.gridView.enableEditOnLongPress         = YES;
    self.gridView.disableEditOnEmptySpaceTap    = YES;
    self.gridView.minEdgeInsets                 = UIEdgeInsetsMake(20, 5, 5, 5);
    self.gridView.verticalItemSpacing           = kVerticalGridSpacing;
    self.gridView.horizontalItemSpacing         = kHorizontalGridSpacing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGrid];

    self.gridViewController.gridView    = self.gridView;
    self.headerLabel.text               = self.headerLabelText;
    self.noContentWarningView           = [self createNoContentWarningView];
    self.noContentWarningView.hidden    = YES;
    [self.contentView addSubview:self.noContentWarningView];
    
    [self loadData];
}

- (void)loadData
{
    [self.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    self.contentView.hidden = YES;
    [self.gridViewController reloadData:^
    {
        self.contentView.hidden = NO;
        [self.loadingView endLoading];
        [self dataDidFinishLoading];
    }
    errorHandler:^(NSError *error)
    {
        [self.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
    }];
}

- (void)dataDidFinishLoading
{
    [self updateUIVisibility];
    // Default impl does nothing. re-implement in subclasses.
}

- (UIView*)createNoContentWarningView
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderLabelText:(NSString *)headerLabelText
{
    _headerLabelText = headerLabelText;
    self.headerLabel.text = headerLabelText;
}

- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    if ([gridCell.dataObject isKindOfClass:[Video class]])
    {
        Video* video = (Video*)gridCell.dataObject;
        
        [VideoPlaybackViewController presentVideo:video fromChannel:nil withNavigationController:self.navigationController];
    }
}

- (void)gridViewController:(GridViewController *)gridViewController changedEdit:(BOOL)edit
{
    [self updateEditButtonState:edit];
    
    if (!edit)
    {
        [self updateUIVisibility];
    }
}

- (void)updateEditButtonState:(BOOL)editing
{
    NSString *text = editing ? NSLocalizedString(@"DoneLKey", @"") : NSLocalizedString(@"EditLKey", @"");
    [self.editButton setTitle:text forState:UIControlStateNormal];
}

- (void)updateEditButtonVisibility:(BOOL)hasData
{
    self.noContentWarningView.hidden = hasData;
    self.headerLabel.hidden = !hasData;
    self.editButton.hidden = !(self.showEditButton && hasData);
}

- (void)updateUIVisibility
{
    [self.dataSource updateTotalObjectCount:^
    {
        BOOL hasData =  self.dataSource.cachedTotalItemCount > 0;
        [self updateEditButtonVisibility:hasData];
    } errorHandler:nil];
}

- (IBAction)didTapEditButton:(id)sender
{
    self.gridView.editing = !self.gridView.editing;
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self loadData];
}

- (void)layoutNoContentWarningView
{
    // Center the noContentWarningView in its superview.
    CGRect frame = self.noContentWarningView.frame;
    frame.origin.x = (self.contentView.frame.size.width  / 2) - (frame.size.width  / 2);
    frame.origin.y = (self.contentView.frame.size.height / 2) - (frame.size.height / 2);
    self.noContentWarningView.frame = frame;
}

- (void)viewDidLayoutSubviews
{
    [self layoutNoContentWarningView];
}

- (void)gridViewController:(GridViewController *)gridViewController processDeletionOfObject:(NSObject *)object
{
    BOOL deletingLastItem = self.dataSource.cachedTotalItemCount == 1;
    self.editButton.hidden = deletingLastItem;
}

@end
