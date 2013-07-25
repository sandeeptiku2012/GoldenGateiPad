//
//  MainSearchResultViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "MainSearchResultViewController.h"
#import "EntityCellView.h"
#import "GlobalSearchModel.h"
#import "EntityModalViewController.h"
#import "GridCellWrapper.h"
#import "VideoCellView.h"
#import "EntityVideoPlayBackViewController.h"

@interface MainSearchResultViewController ()

//table view to display search result
@property(weak, nonatomic) IBOutlet UITableView *tableView;
//loading view to show data fetch in progress
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;
//view of the controller
@property(weak, nonatomic) IBOutlet UIView *contentView;
//UITableViewCell used for table view
@property(strong, nonatomic) TitleWithGridViewCell *prototypeCell;
//array that holds the controller for different panels on the view
@property(strong, nonatomic) NSMutableArray* controllerArray;
//array of pre created table cells
@property(strong, nonatomic) NSMutableArray *tableCellsPrecreated;


@property(weak, nonatomic) ContentCategory *category;

@end

static NSString *cellIDForSearch;

@implementation MainSearchResultViewController

+ (void)initialize
{
    if (cellIDForSearch == nil)
    {
        cellIDForSearch = NSStringFromClass([TitleWithGridViewCell class]);
    }
}


// initialization function
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    self.title = NSLocalizedString(@"SearchResultsLKey", @"");
    
    
    [self setupTableView];
    [self precreateTableCells];
    
    self.navigationItem.leftBarButtonItem.isAccessibilityElement=YES;
    self.navigationItem.leftBarButtonItem.accessibilityLabel=@"Backbtn";
    NSLog(@"%@",self.navigationItem.leftBarButtonItem.title);
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)executeSearchWithSearchString:(NSString*)searchString
{
    // Search is executed to obtain results for Channels, Shows and Videos
    for (int iCount = kChannelsIndex; iCount < kTotalScreens; iCount++) {
        [self executeSearchWithString:searchString searchScope:[self getSearchScopeForType:iCount] type:iCount];
    }
}

// The string to be searched and the scope under which search has to be done is passed. The function
//  runs the search and updates the UI
- (void)executeSearchWithString:(NSString*)searchString
                    searchScope:(SearchScope)searchScope
                   type:(SEARCH_SCREEN_INDEX_ENUM)type
{
    [self showLoadingIndicatorWithMessage:NSLocalizedString(@"SearchingLKey", @"") forType:type];
    [[GlobalSearchModel sharedInstance]executeFullSearchWithString:searchString
                                                    forSearchScope:searchScope
                                                    successHandler:^(NSUInteger totalObjectCount)
     {
         [self reloadGridForType:type];
         
     }
                                                      errorHandler:^(NSError *error)
     {
         [self showRetryWithMessage:NSLocalizedString(@"SearchErrorLKey", @"") forType:type];
     }];
}

// Show loading indicator for the table cell for SEARCH_SCREEN_INDEX
-(void)showLoadingIndicatorWithMessage:(NSString*)strMsg forType:(SEARCH_SCREEN_INDEX_ENUM)type
{
    
    if ([self.tableCellsPrecreated count]>type) {
        TitleWithGridViewCell* cellForController = [self.tableCellsPrecreated objectAtIndex:type];
        [cellForController showLoadingIndicatorWithText:strMsg];
    }
}

// Show retry with message for the table cell for SEARCH_SCREEN_INDEX
-(void)showRetryWithMessage:(NSString*)strMsg forType:(SEARCH_SCREEN_INDEX_ENUM)type
{
    if ([self.tableCellsPrecreated count]>type) {
        TitleWithGridViewCell* cellForController = [self.tableCellsPrecreated objectAtIndex:type];
        [cellForController showRetryWithMessage:strMsg];
    }
}

// Reload the grid view for the table cell at a SEARCH_SCREEN_INDEX
-(void)reloadGridForType:(SEARCH_SCREEN_INDEX_ENUM)type
{
    if (([self.controllerArray count]> type)&&([self.tableCellsPrecreated count]>type)) {
        
        // obtain controller for a type
        GridViewController* gridController = [self.controllerArray objectAtIndex:type];
        
        // obtain table cell for a type
        TitleWithGridViewCell* cellForController = [self.tableCellsPrecreated objectAtIndex:type];
        
        // operation to reload the controller
        NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
            [self reloadDataForController:gridController cellView:cellForController];
        }];
        
        // the operation is queued
        [self.viewControllerOperationQueue addOperation:reloadController];
    }

}

#pragma mark - Private methods

//initialize the tableview
- (void)setupTableView
{
    self.tableView.accessibilityLabel=@"Search Table";
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.tableView registerNib:[UINib nibWithNibName:cellIDForSearch bundle:nil] forCellReuseIdentifier:cellIDForSearch];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    [self.contentView setHidden:NO];
    
}

// reload data for a panel, by reloading the associated controller
-(void)reloadDataForController:(GridViewController*)gridController cellView:(TitleWithGridViewCell*)cellView
{

    [cellView showLoadingIndicatorWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    [gridController reloadData:^{
        [cellView hideLoadingIndicator];
        if(gridController.dataSource.cachedTotalItemCount <= 0)
        {
            [cellView showMessage:NSLocalizedString(@"NoContentToDisplayLKey", @"")];
        }

        
    } errorHandler:^(NSError *error){
        [cellView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
    }];
}


// Pre create different panels to be loaded. This is done as the number of cells are fixed
// and the cells are complex
-(void)precreateTableCells
{
    // flushing off existing cells before pre creating
    [self.tableCellsPrecreated removeAllObjects];
    [self.controllerArray removeAllObjects];
    
    UITableViewCell* cell = nil;
    GridViewController* controller = nil;
    for (int iCount = kChannelsIndex; iCount < kTotalScreens; iCount++) {
        cell = [self getCellForIndex:iCount];
        cell.tag = iCount;
        [self.tableCellsPrecreated insertObject:cell atIndex:iCount];
        controller = [self getControllerForType:iCount dataSource:[self getPrefetchingDataSourceForType:iCount]];
        [self.controllerArray insertObject:controller atIndex:iCount];
    }
    
    
}


#pragma mark - Screen Specific Functions

// Obtain search scope to be used while running search query
-(SearchScope)getSearchScopeForType:(SEARCH_SCREEN_INDEX_ENUM)type
{
    SearchScope retSearch = SearchScopeChannels;
    switch (type) {
        case SearchScopeChannels:
            retSearch = SearchScopeChannels;
            break;
        case SearchScopeShows:
            retSearch = SearchScopeShows;
            break;
        case SearchScopeVideos:
            retSearch = SearchScopeVideos;
            break;
            
        default:
            break;
    }
    
    return retSearch;
}


// Get title for each panel cell
-(NSString*)getTitleForIndex:(SEARCH_SCREEN_INDEX_ENUM)type
{
    NSString* strRet = nil;
    switch (type) {
        case kChannelsIndex:
            strRet = NSLocalizedString(@"ChannelsLKey", @"");
            break;
        case kShowsIndex:
            strRet = NSLocalizedString(@"ShowsLKey", @"");
            break;
        case kVideosIndex:
            strRet = NSLocalizedString(@"VideosLKey", @"");
            break;
            
        default:
            break;
    }
    
    return strRet;
}

// Get number of rows for each panel cell
-(int)getNumRowsForIndex:(SEARCH_SCREEN_INDEX_ENUM)type
{
    int numRows = 1;
    switch (type) {
        case kChannelsIndex:
        case kVideosIndex:
        case kShowsIndex:
            numRows = 2;
            break;
            
        default:
            break;
    }
    
    return numRows;
}


// Get view class for each panel cell
-(Class)getViewClassForIndex:(SEARCH_SCREEN_INDEX_ENUM)type
{
    Class className;
    switch (type) {
        case kChannelsIndex:
            case kShowsIndex:
            className = [EntityCellView class];
            
            break;
            
            case kVideosIndex:
            className = [VideoCellView class];
            break;
        default:
            break;
    }
    
    return className;
}


// Get table view cell for an index. From index the type of panel to be displayed is identified
-(UITableViewCell*)getCellForIndex:(SEARCH_SCREEN_INDEX_ENUM)type
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[self getViewClassForIndex:type] numRows:[self getNumRowsForIndex:type]];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:[self getTitleForIndex:type]];
    cell.delegate = self;
    return cell;
}

// Get controller for a type of table view cell
-(GridViewController*)getControllerForType:(SEARCH_SCREEN_INDEX_ENUM)type dataSource:(PrefetchingDataSource*)pfDataSource
{
    GridViewController* gridController = nil;

    CellViewFactory *cellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[self getViewClassForIndex:type]];

    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>type) {
        cell = [self.tableCellsPrecreated objectAtIndex:type];
    }
    
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:cellFactory dataSource:pfDataSource];
        gridController.delegate = self;
        gridController.gridView.tag = type;
    }
    
    return gridController;
}

// Get prefetching data source for a panel type
-(PrefetchingDataSource*)getPrefetchingDataSourceForType:(SEARCH_SCREEN_INDEX_ENUM)type
{
    PrefetchingDataSource* dataSource = nil;
    
    switch (type) {
        case kChannelsIndex:
            dataSource = [[GlobalSearchModel sharedInstance]fullSearchDataSourceForSearchScope:SearchScopeChannels];            
            break;
        case kShowsIndex:
            dataSource = [[GlobalSearchModel sharedInstance]fullSearchDataSourceForSearchScope:SearchScopeShows];
            break;
        case kVideosIndex:
            dataSource = [[GlobalSearchModel sharedInstance]fullSearchDataSourceForSearchScope:SearchScopeVideos];
            break;
            
        default:
            break;
    }
    
    return dataSource;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 100;
    
    TitleWithGridViewCell* cell = nil;
    
    if (indexPath.row < kTotalScreens) {
        if (([self.tableCellsPrecreated count]>=kTotalScreens)&&([self.tableCellsPrecreated count]>indexPath.row)) {
            cell = [self.tableCellsPrecreated objectAtIndex:indexPath.row];
            fHeight = cell.frame.size.height;
        }
    }
    
    return fHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return kTotalScreens;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleWithGridViewCell* cell = nil;
    if (indexPath.row < kTotalScreens) {
        if ([self.tableCellsPrecreated count]>=kTotalScreens) {
            cell = [self.tableCellsPrecreated objectAtIndex:indexPath.row];
        }
        
    }
    
    return cell;
}


#pragma mark - Properties

- (TitleWithGridViewCell *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    return _prototypeCell;
}

- (NSMutableArray *)controllerArray
{
    if (_controllerArray == nil)
    {
        _controllerArray = [NSMutableArray new];
    }
    
    return _controllerArray;
}

- (NSMutableArray *)tableCellsPrecreated
{
    if (_tableCellsPrecreated == nil)
    {
        _tableCellsPrecreated = [NSMutableArray new];
    }
    
    return _tableCellsPrecreated;
}

#pragma mark - Properties

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)entityCellSelected:(EntityCellView *)entityCellView
{
    [EntityModalViewController showFromView:entityCellView withEntity:(Entity*)entityCellView.entity navController:self.navigationController];
}

- (void)videoCellSelected:(VideoCellView *)videoCellView
{
    [EntityVideoPlayBackViewController presentVideo:videoCellView.video fromEntity:nil withNavigationController:self.navigationController];
}


#pragma mark - Grid View delegates
//gridview controller delegate
- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    if ([gridCell.cellView isKindOfClass:[EntityCellView class]])
    {
        [self entityCellSelected:((EntityCellView*)[gridCell cellView])];
    }else if([gridCell.cellView isKindOfClass:[VideoCellView class]])
    {
        [self videoCellSelected:(VideoCellView*)[gridCell cellView]];
    }
}

- (void)gridViewController:(GridViewController *)gridViewController currentPageChanged:(NSUInteger)currentPage pageCount:(NSUInteger)pageCount
{
    SEARCH_SCREEN_INDEX_ENUM type = gridViewController.gridView.tag;
    if ((type >= kChannelsIndex)&&(type<kTotalScreens)) {
        TitleWithGridViewCell* cell = [self.tableCellsPrecreated objectAtIndex:type];
        [cell setPageCounter:currentPage count:pageCount];
    }
    
}

#pragma mark - TitleWithGridViewCell delegates

-(void)retryPressedInTitleWithViewCell:(id)sender
{
    TitleWithGridViewCell* cell = (TitleWithGridViewCell*)sender;
    int indexInArray = cell.tag;
    
    if (indexInArray < [self.controllerArray count]) {
        GridViewController* gridController = [self.controllerArray objectAtIndex:indexInArray];
        NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
            [self reloadDataForController:gridController cellView:cell];
        }];
        [self.viewControllerOperationQueue addOperation:reloadController];
        
    }
}


@end
