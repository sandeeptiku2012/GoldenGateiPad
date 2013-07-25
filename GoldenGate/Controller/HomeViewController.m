//
//  HomeViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 04/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "TitleWithGridViewCell.h"
#import "EntityCellView.h"
#import "PopularChannelsForCategoryDataFetcher.h"
#import "PopularShowsForCategoryDataFetcher.h"
#import "FeaturedItemsForCategoryDataFetcher.h"
#import "PrefetchingDataSource.h"
#import "GridViewController.h"
#import "GridCellWrapper.h"
#import "FeaturedContentCellView.h"
#import "ChannelsForGenreCell.h"
#import "Constants.h"
#import "EntityModalViewController.h"
#import "FeaturedContentNavigator.h"
#import "CollectionCellWrapper.h"
#import "VimondStore.h"
#import "Channel.h"


@interface HomeViewController ()


@property(weak, nonatomic) IBOutlet UITableView *tableView;//table view to show the channel list
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;//loading view to show data fetch in progress
@property(weak, nonatomic) IBOutlet UIView *contentView;//view of the controller
@property(strong, nonatomic) TitleWithGridViewCell *prototypeCell;//UITableViewCell used for table view

@property(strong, nonatomic) NSMutableArray* controllerArray;
@property(strong, nonatomic) NSMutableArray *tableCellsPrecreated;//List of pre created cells

@property(strong, nonatomic)  NSArray *featureCollection; //to populate the featured collection cell
@property(strong, nonatomic)  CollectionViewController *featuredCollectionViewcontroller; //controlller for the cell of featured content

@property(strong, nonatomic) CellViewFactory* viewFactoryFeaturedChannelCells; //cell to create different size cell for featured channel type
@property(strong, nonatomic) CellViewFactory* viewFactoryFeaturedCells;  //cell to create different size cell for  other featured content type



@property(weak, nonatomic) ContentCategory *category;

@end


static NSString *cellIDForHome;





@implementation HomeViewController

+ (void)initialize
{
    if (cellIDForHome == nil)
    {
        cellIDForHome = NSStringFromClass([TitleWithGridViewCell class]);
    }
}




- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNavAction:navAction]))
    {
        CategoryAction *categoryAction = (CategoryAction *)navAction.parentAction;
        self.category = categoryAction.category;
    }
    
    return self;
}



//initialization function
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    [self setupTableView];
    [self precreateTableCells];
    self.tableView.accessibilityLabel = @"Home Table";
    [self loadDataFromCategory:self.category refreshScreens:kTotalScreens];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

//initialize the tableview
- (void)setupTableView
{
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.tableView registerNib:[UINib nibWithNibName:cellIDForHome bundle:nil] forCellReuseIdentifier:cellIDForHome];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    [self.contentView setHidden:NO];
    
}


//function to load data to table

- (void)loadDataFromCategory:(ContentCategory*)category refreshScreens:(HOME_SCREEN_INDEX_ENUM)screenType
{
    if ((screenType >= kUPNextIndex) && (screenType <= kTotalScreens))
    {
        TitleWithCollectionViewCell *cell = [self.tableCellsPrecreated objectAtIndex:kFeaturedIndex];
        [cell showLoadingIndicatorWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
        __block int numberOfErrors = 0;
        
        NSOperation *updateUI = [NSBlockOperation blockOperationWithBlock:^{
            if (numberOfErrors == 0)
            {
                [cell hideLoadingIndicator];
                if ((nil == self.featureCollection)||(0==[self.featureCollection count])) {
                    [cell showMessage:NSLocalizedString(@"NoContentToDisplayLKey", @"")];
                }else{
                    
                [self updateFromFeaturedCollection:self.featureCollection ];
                    
                }
                
            }
            else
            {
                [cell showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
            }
        }];
        
        
        int iIndexController = 0;
        TitleWithGridViewCell* cellForController = nil;
        for (NSObject* viewController in self.controllerArray)
        {
            if ([viewController isKindOfClass:([GridViewController class])])
            {
                if ((screenType == kTotalScreens)||(screenType == kUPNextIndex) || (screenType == kPopularChannelsIndex) || (screenType == kPopularIndex))
                {
                    if ([self.tableCellsPrecreated count]>iIndexController) {
                        cellForController = [self.tableCellsPrecreated objectAtIndex:iIndexController];
                    }else{
                        cellForController = nil;
                    }
                    
                    
                    GridViewController *gridController = (GridViewController*)viewController;
                    NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
                        [self reloadDataForController:gridController contentCategory:self.category cellView:cellForController];
                    }];
                    [updateUI addDependency:reloadController];
                    [self.viewControllerOperationQueue addOperation:reloadController];
                    
                
                }
                
            }
            else if([viewController isKindOfClass:([CollectionViewController class])])
            {
                if ((screenType == kTotalScreens)||(screenType == kFeaturedIndex))
                {
                    NSOperation *updateFeatured = [NSBlockOperation blockOperationWithBlock:^{
                        
                        NSError *error = nil;
                        self.featureCollection = [[VimondStore contentPanelStore] featuredContentPanelForCategory:category error:&error];
                        if (error) {
                            numberOfErrors++;
                        }
                        
                    }];
                    
                    [updateUI addDependency:updateFeatured];
                    [self.viewControllerOperationQueue addOperation:updateFeatured];
                    
                }
                
            }
            iIndexController++;
        }
        
        [[NSOperationQueue mainQueue] addOperation:updateUI];
        
    }
    
}


//  function to reload data for a particular controller acoording to category and cellview
-(void)reloadDataForController:(GridViewController*)gridController contentCategory:(ContentCategory*)category cellView:(TitleWithGridViewCell*)cellView
{
   
    ObjectAsSourceDataFetcher* dataFetcher = gridController.dataSource.dataFetcher;
    dataFetcher.sourceObject = category;
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


//function to set the category for grid view controllers
-(void)setCategoryForDataFetchers:(ContentCategory*)category
{
    for (NSObject* viewcontroller in self.controllerArray)
    {        
        if ([viewcontroller isKindOfClass:([GridViewController class])])
        {
            GridViewController *gridViewController = (GridViewController*)viewcontroller;
            ObjectAsSourceDataFetcher* dataFetcher = gridViewController.dataSource.dataFetcher;
            dataFetcher.sourceObject = category;
        }
    }
}


//precreated cells and controllers added to thier corresponding arrays to populate the table view

-(void)precreateTableCells
{
    [self.tableCellsPrecreated removeAllObjects];
    [self.controllerArray removeAllObjects];
    
    UITableViewCell* cell = [self getCellForUpNext];
    cell.tag = kUPNextIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kUPNextIndex];
    GridViewController* controller = [self getControllerForUpNext];    
    [self.controllerArray insertObject:controller atIndex:kUPNextIndex];
    
    
    cell = [self getCellForFeatured];
    cell.tag = kFeaturedIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kFeaturedIndex];
    CollectionViewController* collectionController = [self getControllerForFeatured];
    [self.controllerArray insertObject:collectionController atIndex:kFeaturedIndex];
    
    cell = [self getCellForPopularShows];
    cell.tag = kPopularIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kPopularIndex];
    controller = [self getControllerForPopularShows];
    [self.controllerArray insertObject:controller atIndex:kPopularIndex];
    
    cell = [self getCellForPopularChannels];
    cell.tag = kPopularChannelsIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kPopularChannelsIndex];
    controller = [self getControllerForPopularChannels];
    [self.controllerArray insertObject:controller atIndex:kPopularChannelsIndex];
    
    
}

#pragma mark - Screen Specific Functions

//returns the cell for UPNext cell
-(UITableViewCell*)getCellForUpNext
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[EntityCellView class] numRows:1];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"UpNextLKey", @"")];
    cell.delegate = self;
     cell.accessibilityLabel = @"Up Next Grid";
    return cell;
}

//returns the controller for UPNext cell
-(GridViewController*)getControllerForUpNext
{
    GridViewController* gridController = nil;

    CellViewFactory *upNextCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    
    PopularChannelsForCategoryDataFetcher* popularEntitiesForCategoryDataFetcher = [PopularChannelsForCategoryDataFetcher new];
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:popularEntitiesForCategoryDataFetcher];
    dataSource.sortBy = ProgramSortByRatingCount;
    
    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kUPNextIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kUPNextIndex];
    }
    
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:upNextCellFactory dataSource:dataSource];
        gridController.delegate = self;
    }    
    
    return gridController;
}


//returns the cell for featured collection cell
-(UITableViewCell*)getCellForFeatured
{
    TitleWithCollectionViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithCollectionViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[FeaturedContentCellView class] numRows:1];
    [cell setFrame:frameCell];
   
    [[cell getTitleLabel] setText:NSLocalizedString(@"FeaturedLKey", @"")];
    cell.delegate = self;
    cell.accessibilityLabel = @"Featured Grid";
    
    return cell;
}



//returns the controller for featured collection cell
-(CollectionViewController*)getControllerForFeatured
{
    self.featuredCollectionViewcontroller = nil;
    TitleWithCollectionViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kFeaturedIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kFeaturedIndex];
    }
    if (cell) {
        self.featuredCollectionViewcontroller = [[CollectionViewController alloc] initWithView:[cell getFeaturedCollectionView] ];
        self.featuredCollectionViewcontroller.delegate = self;
    }
    
    return self.featuredCollectionViewcontroller;
}


//returns the cell for popular shows cell
-(UITableViewCell*)getCellForPopularShows
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[EntityCellView class] numRows:1];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"PopularShowsLKey", @"")];
    cell.delegate = self;
     cell.accessibilityLabel = @"Popular Shows Grid";
    
    return cell;
}


//returns the controller  for popular shows cell
-(GridViewController*)getControllerForPopularShows
{
    GridViewController* gridController = nil;

    CellViewFactory *showsCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    
    PopularShowsForCategoryDataFetcher* popularEntitiesForCategoryFetcher = [PopularShowsForCategoryDataFetcher new];
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:popularEntitiesForCategoryFetcher];
    dataSource.sortBy = ProgramSortByRatingCount;
    
    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kPopularIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kPopularIndex];
    }
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:showsCellFactory dataSource:dataSource];
        gridController.delegate = self;
    }
    
    return gridController;
}



//returns the cell for popular channels cell
-(UITableViewCell*)getCellForPopularChannels
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[EntityCellView class] numRows:1];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"PopularChannelsLKey", @"")];
    cell.delegate = self;
      cell.accessibilityLabel = @"Popular Channels Grid";
    return cell;
}




//returns the controller for popular channels cell

-(GridViewController*)getControllerForPopularChannels
{
    GridViewController* gridController = nil;
    CellViewFactory *channelCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    
    PopularChannelsForCategoryDataFetcher* popularEntitiesForCategoryFetcher = [PopularChannelsForCategoryDataFetcher new];
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:popularEntitiesForCategoryFetcher];
    dataSource.sortBy = ProgramSortByRatingCount;
    
    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kPopularChannelsIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kPopularChannelsIndex];
    }
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:channelCellFactory dataSource:dataSource];
        gridController.delegate = self;
    }
    
    return gridController;
}

#pragma mark - featured panel CollectionView methods

// updates the featured collection cell 
- (void)updateFromFeaturedCollection:(NSArray *)featuredCollectionArray
{
   
    [self.featuredCollectionViewcontroller reloadData:featuredCollectionArray];
}


//creats different size cells for the featured collectionView

-(CellView*)featuredPanelCellForData:(NSObject*)objData
{
    CellView* cell = nil;
    
    if([objData isKindOfClass:[FeaturedContent class]])
    {
        FeaturedContent* content = (FeaturedContent*)objData;
        if ((content.contentType == FeaturedContentTypeEntity)&&([content.displayEntity isKindOfClass:[Channel class]])) {
            cell = [self.viewFactoryFeaturedChannelCells createCellView];
        }else{
            cell = [self.viewFactoryFeaturedCells createCellView];
        }
    }
    
    return cell;
}


//getters for viewfactory properties

- (CellViewFactory*)viewFactoryFeaturedCells
{
    if (nil == _viewFactoryFeaturedCells) {
        _viewFactoryFeaturedCells = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[FeaturedContentCellView class]];
    }
    
    return _viewFactoryFeaturedCells;
}

- (CellViewFactory*)viewFactoryFeaturedChannelCells
{
    if (nil == _viewFactoryFeaturedChannelCells) {
        _viewFactoryFeaturedChannelCells = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSquare cellViewClass:[FeaturedContentCellView class]];
    }
    
    return _viewFactoryFeaturedChannelCells;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 100;
    
    UITableViewCell* cell = nil;

    if (indexPath.row < kTotalScreens) {
        if ([self.tableCellsPrecreated count]>=kTotalScreens) {
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
    
    UITableViewCell* cell = nil;
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


//getter for the list of controllers of tableview cells

- (NSMutableArray *)controllerArray
{
    if (_controllerArray == nil)
    {
        _controllerArray = [NSMutableArray new];
    }
    
    return _controllerArray;
}



//getter for the precreated cell list

- (NSMutableArray *)tableCellsPrecreated
{
    if (_tableCellsPrecreated == nil)
    {
        _tableCellsPrecreated = [NSMutableArray new];
    }
    
    return _tableCellsPrecreated;
}

#pragma mark - Properties

//setter for category
- (void)setCategory:(ContentCategory *)category
{
    _category = category;
    
    [self setCategoryForDataFetchers:category];
    
    if (self.isViewLoaded)
    {
        [self loadDataFromCategory:category refreshScreens:kTotalScreens];
    }
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


//gets call on the selection of an entity cell other than featuredCollection
- (void)entityCellSelected:(EntityCellView *)entityCellView
{
    [EntityModalViewController showFromView:entityCellView withEntity:(Entity*)entityCellView.entity navController:self.navigationController];
}


//gets call on selection of the featured collection cell
- (void)featuredCellSelected:(FeaturedContentCellView *)featuredCellView
{
    FeaturedContent *featuredContent = featuredCellView.featuredContent;
    
    [featuredCellView showLoadingIndicator];
    [FeaturedContentNavigator navigateToFeaturedContent:featuredContent
                                     fromViewController:self
                                      completionHandler:^
     {
         [featuredCellView hideLoadingIndicator];
     }];
}

#pragma mark - Grid View delegates
//gridview controller delegate
- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    if ([gridCell.cellView isKindOfClass:[EntityCellView class]])
    {
        [self entityCellSelected:((EntityCellView*)[gridCell cellView])];
    }else if([gridCell.cellView isKindOfClass:[FeaturedContentCellView class]])
    {
        [self featuredCellSelected:((FeaturedContentCellView*)[gridCell cellView])];
    }
}

#pragma mark - TitleWithCollectionViewCell delegates


//called when retry button was preesed in the featured collection view
-(void) retryPressedInTitleWithCollectionViewCell : (id) sender
{
    
            NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
                
                [self loadDataFromCategory:self.category refreshScreens:kFeaturedIndex];
            
        }];
    
        [self.viewControllerOperationQueue addOperation:reloadController];
}



#pragma mark - TitleWithGridViewCell delegates


//called when retry button was preesed in the grid view
-(void)retryPressedInTitleWithViewCell:(id)sender
{
    TitleWithGridViewCell* cell = (TitleWithGridViewCell*)sender;
    int indexInArray = cell.tag;
    
    if (indexInArray < [self.controllerArray count]) {
        GridViewController* gridController = [self.controllerArray objectAtIndex:indexInArray];
        NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
            [self reloadDataForController:gridController contentCategory:self.category cellView:cell];
        }];
        [self.viewControllerOperationQueue addOperation:reloadController];
        
    }
}


#pragma mark - CollectionViewController delegates

- (void)collectionView:(UICollectionView *)collectionView didSelectCell:(CollectionCellWrapper*)gridCell
{
    if ([gridCell.cellView isKindOfClass:[EntityCellView class]])
    {
        [self entityCellSelected:(EntityCellView*)[gridCell cellView]];
    }else if([gridCell.cellView isKindOfClass:[FeaturedContentCellView class]])
    {
        [self featuredCellSelected:((FeaturedContentCellView*)[gridCell cellView])];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didUnselectCell:(CollectionCellWrapper*)gridCell
{
    //no implementation
}


- (CGSize) cellSizeForData:(NSObject*)objData
{
    CGSize sizeRet;
    CellView* cell = [self featuredPanelCellForData:objData];
    sizeRet = cell.frame.size;
    return sizeRet;    
}


- (CellView*) cellForData:(NSObject*)objData
{
    CellView* cell = [self featuredPanelCellForData:objData];    
    return cell;    
}



@end











