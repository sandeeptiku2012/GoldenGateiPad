//
//  MainCategoryViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "MainCategoryViewController.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "TitleWithGridViewCell.h"
#import "EntityCellView.h"
#import "PopularChannelsForCategoryDataFetcher.h"
#import "ChannelsForCategoryDataFetcher.h"
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

#define numItemsPerPageGridView 6


@interface MainCategoryViewController ()
{
    
}


@property(weak, nonatomic) IBOutlet UITableView *tableView;//table view to show the channel list
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;//loading view to show data fetch in progress
@property(weak, nonatomic) IBOutlet UIView *contentView;//view of the controller
@property(strong, nonatomic) TitleWithGridViewCell *prototypeCell;//UITableViewCell used for table view

@property(strong, nonatomic) NSMutableArray* controllerArray;  //list of controllers
@property(strong, nonatomic) NSMutableArray *tableCellsPrecreated;//List of pre created cells

@property(strong, nonatomic)  NSArray *featureCollection; //to populate the featured collection cell
@property(strong, nonatomic)  CollectionViewController *featuredCollectionViewcontroller; //controlller for the cell of featured content

@property(strong, nonatomic) CellViewFactory* viewFactoryFeaturedChannelCells; //cell to create different size cell for featured channel type
@property(strong, nonatomic) CellViewFactory* viewFactoryFeaturedCells; //cell to create different size cell for  other featured content type



@property(weak, nonatomic) ContentCategory *category;


@end

static NSString *cellIDForStore;


@implementation MainCategoryViewController


+ (void)initialize
{
    if (cellIDForStore == nil)
    {
        cellIDForStore = NSStringFromClass([TitleWithGridViewCell class]);
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
    [self loadDataFromCategory:self.category refreshScreens:kSSTotalScreens];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:cellIDForStore bundle:nil] forCellReuseIdentifier:cellIDForStore];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    [self.contentView setHidden:NO];
    
}


//function to load data to table

- (void)loadDataFromCategory:(ContentCategory*)category refreshScreens:(STORE_SCREEN_INDEX_ENUM)screenType
{
    
    if ((screenType >= kSSFeaturedIndex) && (screenType <= kSSTotalScreens))
    {
        TitleWithCollectionViewCell *cell = [self.tableCellsPrecreated objectAtIndex:kSSFeaturedIndex];
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
                if ((screenType == kSSTotalScreens) || (screenType == kSSA2ZChannelsIndex) ||(screenType == kSSPopularChannelsIndex))
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
                if ((screenType == kSSTotalScreens)||(screenType == kSSFeaturedIndex))
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
    
    UITableViewCell* cell = [self getCellForFeatured];
    cell.tag = kSSFeaturedIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kSSFeaturedIndex];
    CollectionViewController* collectionController = [self getControllerForFeatured];
    [self.controllerArray insertObject:collectionController atIndex:kSSFeaturedIndex];
        
    cell = [self getCellForPopularChannels];
    cell.tag = kSSPopularChannelsIndex;
    [self.tableCellsPrecreated insertObject:cell atIndex:kSSPopularChannelsIndex];
    GridViewController* controller = [self getControllerForPopularChannels];
    [self.controllerArray insertObject:controller atIndex:kSSPopularChannelsIndex];
    
    cell = [self getCellForChannelsAtoZ];
    cell.tag = kSSA2ZChannelsIndex;
    
    [self.tableCellsPrecreated insertObject:cell atIndex:kSSA2ZChannelsIndex];
    controller = [self getControllerForChannelsAtoZ];
    [self.controllerArray insertObject:controller atIndex:kSSA2ZChannelsIndex];
    
  }

#pragma mark - Screen Specific Functions

//returns the cell for featured collection cell
-(UITableViewCell*)getCellForFeatured
{
    TitleWithCollectionViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithCollectionViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[FeaturedContentCellView class] numRows:1];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"FeaturedLKey", @"")];
    cell.delegate = self;
    
    return cell;
}

//returns the controller for featured collection cell
-(CollectionViewController*)getControllerForFeatured
{
    self.featuredCollectionViewcontroller = nil;
    TitleWithCollectionViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kSSFeaturedIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kSSFeaturedIndex];
    }
    if (cell) {
        self.featuredCollectionViewcontroller = [[CollectionViewController alloc] initWithView:[cell getFeaturedCollectionView] ];
        self.featuredCollectionViewcontroller.delegate = self;
    }
    self.featuredCollectionViewcontroller.accessibilityLabel=@"Featured";
    return self.featuredCollectionViewcontroller;
}


//returns the cell for ChannelsAtoZ cell
-(UITableViewCell*)getCellForChannelsAtoZ
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[EntityCellView class] numRows:1];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"ChannelsAtoZLKey", @"")];
    cell.delegate = self;
    
    return cell;
}

//returns the controller for ChannelsAtoZ cell

-(GridViewController*)getControllerForChannelsAtoZ
{
    GridViewController* gridController = nil;
    CellViewFactory *showsCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    ChannelsForCategoryDataFetcher *channelsForCategoryDataFetcher = [ChannelsForCategoryDataFetcher new];
    channelsForCategoryDataFetcher.sourceObject = self.category;
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:channelsForCategoryDataFetcher];
    dataSource.sortBy = ProgramSortByCategoryNameAsc;
    dataSource.objectsPrPage = numItemsPerPageGridView;
    
    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kSSA2ZChannelsIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kSSA2ZChannelsIndex];
    }
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:showsCellFactory dataSource:dataSource];
        gridController.delegate = self;
    }
      [cell getGridView].accessibilityLabel=@"AtoZ";
    
    return gridController;
}


//returns the cell for popularChannels cell
-(UITableViewCell*)getCellForPopularChannels
{
    TitleWithGridViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleWithGridViewCell" owner:self options:nil]objectAtIndex:0];
    
    CGRect frameCell = cell.contentView.bounds;
    frameCell.size.height = [cell heightOfCellForSubCellofSize:CellSizeSmall viewClass:[EntityCellView class] numRows:2];
    [cell setFrame:frameCell];
    [[cell getTitleLabel] setText:NSLocalizedString(@"PopularChannelsLKey", @"")];
    cell.delegate = self;
    
    return cell;
}


//returns the controller for popularChannels cell
-(GridViewController*)getControllerForPopularChannels
{
    GridViewController* gridController = nil;
    CellViewFactory *channelCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    
    PopularChannelsForCategoryDataFetcher* popularEntitiesForCategoryFetcher = [PopularChannelsForCategoryDataFetcher new];
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:popularEntitiesForCategoryFetcher];
    dataSource.sortBy = ProgramSortByRatingCount;
    
    TitleWithGridViewCell* cell = nil;
    if ([self.tableCellsPrecreated count]>kSSPopularChannelsIndex) {
        cell = [self.tableCellsPrecreated objectAtIndex:kSSPopularChannelsIndex];
    }
    if (cell) {
        gridController = [[GridViewController alloc] initWithGridView:[cell getGridView] gridCellFactory:channelCellFactory dataSource:dataSource];
        gridController.delegate = self;
    }
    [cell getGridView].accessibilityLabel=@"PopularView";
    return gridController;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 100;
    
    TitleWithGridViewCell* cell = nil;
    
    if (indexPath.row < kSSTotalScreens) {
        if ([self.tableCellsPrecreated count]>=kSSTotalScreens) {
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
    
    return kSSTotalScreens;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setAccessibilityLabel:@"Entityvideo"];
    UITableViewCell* cell = nil;
    if (indexPath.row < kSSTotalScreens) {
        if ([self.tableCellsPrecreated count]>=kSSTotalScreens) {
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
        [self loadDataFromCategory:category refreshScreens:kSSTotalScreens];
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

#pragma mark - TitleWithCollectionViewCell delegates


//called when retry button was preesed in the featured collection view
-(void) retryPressedInTitleWithCollectionViewCell : (id) sender
{
    
    NSOperation *reloadController = [NSBlockOperation blockOperationWithBlock:^{
        
        [self loadDataFromCategory:self.category refreshScreens:kSSFeaturedIndex];
        
        
    }];
    
    [self.viewControllerOperationQueue addOperation:reloadController];
    
    
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







@end
