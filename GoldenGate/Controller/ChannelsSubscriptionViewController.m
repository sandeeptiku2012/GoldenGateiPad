//
//  ChannelsSubscriptionViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 13/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelsSubscriptionViewController.h"
#import "ChannelsForGenreCell.h"
#import "MyChannelsDataFetcher.h"
#import "Channel.h"
#import "PrefetchingDataSource.h"
#import "CategoryAction.h"
#import "MyChannelsAction.h"
#import "ChannelsForCategoryDataFetcher.h"
#import "ChannelsbyGenre.h"
#import "VimondStore.h"

#define kNumberOfRowsPrPage 4
#define kDistanceToNextRow 10

@interface ChannelsSubscriptionViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;//table view to show the channel list
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;//loading view to show data fetch in progress
@property(weak, nonatomic) IBOutlet UIView *contentView;//view of the controller
@property(weak, nonatomic) IBOutlet UILabel *tableHeaderLabel;//header label for the view
@property(strong, nonatomic) ChannelsForGenreCell *prototypeCell;//UITableViewCell used for table view
@property(strong, nonatomic) ChannelsbyGenre *channelsForGenre;//channels for each genre stored here

@property(weak, nonatomic) ContentCategory *category;

//@property (strong, nonatomic) NSMutableDictionary *alternateColorDict;
@property(strong, nonatomic) NSArray *channelList;//List of channels obtained from server
@property(strong, nonatomic) NSMutableArray *tableCellsPrecreated;//List of pre created ChannelCellViews. Cells are precreated
                                                                  //to avoid sluggishness in UI
@end

static NSString *cellID;



@implementation ChannelsSubscriptionViewController

+ (void)initialize
{
    if (cellID == nil)
    {
        cellID = NSStringFromClass([ChannelsForGenreCell class]);
    }
}

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNavAction:navAction]))
    {
        NavAction *parentNavAction = navAction.parentAction;
        if ([parentNavAction isKindOfClass:[CategoryAction class]])
        {
            CategoryAction *categoryAction = (CategoryAction *) parentNavAction;
            self.category = categoryAction.category;
        }
    }
    
    return self;
}


-(id)initWithCategory:(ContentCategory*)category
{
    if (self = [super init]) {
        self.category = category;
    }
    return self;
}

//initialization function
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    [self setupTableView];
    [self loadData];
    [self updateHeaderLabel];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
}

//function to load data to table
- (void)loadData
{
   // self.alternateColorDict = [NSMutableDictionary new];
    self.contentView.hidden = YES;
    [self.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    
    __block BOOL bError = false;
    //Subscribed channels obtained using NSOperation
    NSOperation *getChannels = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error = nil;
        self.channelList = [[VimondStore sharedStore] myChannels:&error];
        if (error) {
            bError = TRUE;
            self.channelList = nil;
        }else{
            [self storeDataByGenre:self.channelList];

        }
    }];
    
    
    //NSOperation to update UI after getting the channels
    NSOperation *updateUI = [NSBlockOperation blockOperationWithBlock:^{
        if (bError)
        {
            [self.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
            
            
        }
        else
        {
            if ((!self.channelList)||(0 == [self.channelList count])) {
                [self.loadingView showMessage: [self noContentString]];
            }else
            {
                [self precreateTableCells];
                [self.loadingView endLoading];
                self.contentView.hidden = NO;
                [self.tableView reloadData];
            }
        }
    }];
    
    [updateUI addDependency:getChannels];
    [self.viewControllerOperationQueue addOperation:getChannels];
    
    //updateUI operation run on the main thread
    [[NSOperationQueue mainQueue] addOperation:updateUI];
    
}

- (NSString*)noContentString
{
    return self.category ? NSLocalizedString(@"CategoryHasNoChannelsLKey", @"") : NSLocalizedString(@"UserHasNoChannelsLKey", @"");
}

//Update table header label
- (void)updateHeaderLabel
{
//    NSString *labelText = NSLocalizedString(@"SubscriptionsLKey", @"");
//    if (self.category)
//    {
//        labelText = [NSString stringWithFormat:NSLocalizedString(@"AllOfCategoryLKey", @""), self.navAction.parentAction.name];
//    }
//    
//    self.tableHeaderLabel.text = labelText;
}

//Table view cells are pre created here. This is to remove sluggishness.
//This is suitable for this controller as the data obtained is not paged.
-(void)precreateTableCells
{
    [self.tableCellsPrecreated removeAllObjects];
    for (int iCount = 0; iCount<self.channelsForGenre.itemsCount; iCount++) {
        ChannelsForGenreCell* cell = nil;
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChannelsForGenreCell" owner:self options:nil]objectAtIndex:0];
        NSArray* channelsList = [self getChannelsFromStoreforIndex:iCount];
        CGRect frameCell = cell.contentView.bounds;
        frameCell.size.height = [cell getCellHeightForNumCells:[channelsList count]];
        [cell setFrame:frameCell];
        cell.navController = [self getNavControllerForView];
        cell.channels = channelsList;
        cell.genre = [self getGenreFromStoreforIndex:iCount];
        
        [self.tableCellsPrecreated addObject:cell];
    }

}

//Store channels based on Genre
-(void)storeDataByGenre:(NSArray*)channels
{
    [self.channelsForGenre clearAll];
    [self.channelsForGenre addChannelsFromArray:channels];
}

// Function to obtain navigation controller
-(UINavigationController*)getNavControllerForView
{
    UINavigationController* retController = self.navigationController;
    if (nil == retController) {
        retController = self.custParentNavigationController;
    }
    return retController;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Returns different row heights based on number of cells to be displayed
    float fHeight = [self.prototypeCell getCellHeightForNumCells:1];
    NSArray* channelsForRow = [self getChannelsFromStoreforIndex:indexPath.row];
    if (channelsForRow) {
        fHeight = [self.prototypeCell getCellHeightForNumCells:[channelsForRow count]];
    }
    
    return (fHeight+kDistanceToNextRow);
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
    //returns number of Genres
    return self.channelsForGenre.itemsCount;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ChannelsForGenreCell *cell = nil;
    
    //pre created cells are returned this is to avoid sluggishness of UI
    //The view contains rows of differential heights
    if ([self.tableCellsPrecreated count]> indexPath.row) {
        cell = [self.tableCellsPrecreated objectAtIndex:indexPath.row];
    }
    
    return cell;
}

//Get genre for channels at index
-(NSString*)getGenreFromStoreforIndex:(int)index
{
    NSString* strRet = nil;    
    NSDictionary* dictChannels = [self.channelsForGenre objectAtIndex:index];
    NSArray* arrKeys = [dictChannels allKeys];
    if (arrKeys) {
        strRet = [arrKeys objectAtIndex:0];
    }

    return strRet;
}

//get channels for row
-(NSArray*)getChannelsFromStoreforIndex:(int)index
{
    NSArray* arrRet = nil;
    NSDictionary* dictChannels = [self.channelsForGenre objectAtIndex:index];
    NSArray* arrKeys = [dictChannels allKeys];
    if (nil!=arrKeys) {
        arrRet = [dictChannels objectForKey:arrKeys[0]];
    }

    return arrRet;
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    //Load data again if retry button is clicked
    [self loadData];
}

#pragma mark - Properties

- (ChannelsForGenreCell *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [[[NSBundle mainBundle]loadNibNamed:@"ChannelsForGenreCell" owner:self options:nil]objectAtIndex:0];
    }
    
    return _prototypeCell;
}

- (ChannelsbyGenre *)channelsForGenre
{
    if (_channelsForGenre == nil)
    {
        _channelsForGenre = [ChannelsbyGenre new];
    }
    
    return _channelsForGenre;
}

-(NSMutableArray*)tableCellsPrecreated
{
    if (_tableCellsPrecreated == nil)
    {
        _tableCellsPrecreated = [NSMutableArray new];
    }
    
    return _tableCellsPrecreated;
}



@end
