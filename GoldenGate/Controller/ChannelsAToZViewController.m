//
//  ChannelsAToZViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ChannelsAToZViewController.h"
#import "ChannelSummaryCellPaged.h"
#import "MyChannelsDataFetcher.h"
#import "Channel.h"
#import "PrefetchingDataSource.h"
#import "CategoryAction.h"
#import "MyChannelsAction.h"
#import "ChannelsForCategoryDataFetcher.h"
#import "VideoCache.h"
#import "GGBarButtonItem.h"
#import "GGBarButton.h"
#import "GGPopoverBackgroundView.h"
#import "VimondStore.h"
#import "NavActionExecutor.h"
#import "LogoutAction.h"
#import "CategoryNavigator.h"
#import "AppDelegate.h"


#define kMaxVidsPrChannel 5
#define kNumberOfRowsPrPage 4
#define kCloseButtonindex 0
#define kPopoverButtonindex 1

@interface ChannelsAToZViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) PrefetchingDataSource *prefetchingDataSource;
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;
@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UILabel *tableHeaderLabel;

@property(strong, nonatomic) ChannelSummaryCellPaged *prototypeCell;

@property(weak, nonatomic) ContentCategory *category;
@property(strong, nonatomic) VideoCache *videoCache;

@property (strong, nonatomic) NSMutableDictionary *alternateColorDict;

@property (strong, nonatomic)  NSArray *navButtons; //to store the navigationBarButtonItems

@end

static NSString *cellID;

@implementation ChannelsAToZViewController



+(void) presentChannelsAToZViewControllerwithNavAction : (NavAction*)navAction fromController : (UINavigationController*)navigationController  
{
    
    ChannelsAToZViewController *channelsAToZViewController = [[ChannelsAToZViewController alloc]initWithNavAction:navAction];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:channelsAToZViewController];
    [navigationController presentViewController:nav animated:YES completion:nil];
        
}


#pragma mark - Custom initializers


-(id)initWithCategory:(ContentCategory*)category
{
    if (self = [super init]) {
        self.category = category;
    }
    return self;
}


+ (void)initialize
{
    if (cellID == nil)
    {
        cellID = NSStringFromClass([ChannelSummaryCellPaged class]);
    }
}


- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super initWithNavAction:navAction]))
    {
    
        [self applyNavAction:navAction];
        
    }

    return self;
}

-(void) applyNavAction:(NavAction *)navAction
{
    
    self.navAction = navAction;
    if ([navAction isKindOfClass:[CategoryAction class]])
    {
        CategoryAction *categoryAction = (CategoryAction *) navAction;
        self.category = categoryAction.category;
    }
    
}




#pragma mark - Private methods



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadingView setDelegate:self];
    [self setupNavigationBarAndBackgroundView];
    [self setupTableView];
    [self loadData];
    [self updateHeaderLabel];
    [self createNavigationBarButtons];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.videoCache clearCache];
}


- (void)setupTableView
{
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)loadData
{
    self.alternateColorDict = [NSMutableDictionary new];
    self.contentView.hidden = YES;
    [self.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    self.prefetchingDataSource = [self createPrefetchingDataSource];
    [self.prefetchingDataSource updateTotalObjectCount:^
    {
        if (self.prefetchingDataSource.cachedTotalItemCount > 0)
        {
            [self.loadingView endLoading];
            self.contentView.hidden = NO;
            [self.tableView reloadData];
        }
        else
        {
            [self.loadingView showMessage: [self noContentString]];
        }
    }
    errorHandler:^(NSError *error)
    {
        [self.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
    }];
}




- (NSString*)noContentString
{
    return self.category ? NSLocalizedString(@"CategoryHasNoChannelsLKey", @"") : NSLocalizedString(@"UserHasNoChannelsLKey", @"");
}




- (id<DataFetching>)dataFetcherForCategory:(ContentCategory*)category
{
    
    id<DataFetching> dataFetcher = nil;
    if ([category isKindOfClass:[ContentCategory class]])
    {
        ChannelsForCategoryDataFetcher *channelsForCategoryDataFetcher = [ChannelsForCategoryDataFetcher new];
        channelsForCategoryDataFetcher.sourceObject = self.category;
        dataFetcher = channelsForCategoryDataFetcher;
    }
    return dataFetcher;
    
}


- (PrefetchingDataSource *)createPrefetchingDataSource
{
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:[self dataFetcherForCategory:self.category]];
    dataSource.sortBy = ProgramSortByCategoryNameAsc;
    dataSource.objectsPrPage = kNumberOfRowsPrPage;
    return dataSource;
}

- (void)updateHeaderLabel
{
    NSString *labelText = NSLocalizedString(@"MyChannelsLKey", @"");
    if (self.navAction)
    {
        labelText = [NSString stringWithFormat:@"%@", self.navAction.name];
    }
    
    self.tableHeaderLabel.text = labelText;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.prototypeCell.bounds.size.height;
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
    return self.prefetchingDataSource.cachedTotalItemCount;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelSummaryCellPaged *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.navController = self.navigationController;
    
    [self.prefetchingDataSource fetchDataObjectAtIndex:indexPath.row
                                        successHandler:^(NSObject *dataObject)
    {
        cell.channel = (Channel*)dataObject;        
    } errorHandler:nil];
    
    return cell;
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self loadData];
}


#pragma mark - Properties

- (ChannelSummaryCellPaged *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    }

    return _prototypeCell;
}


-(void) setCategory:(ContentCategory *)category
{

    _category=category;
    
}



#pragma mark - Methods related to popover

-(void) loadDataWithAction : (CategoryAction*) action
{
    [self dismissPopover];
    [self applyNavAction:action];
    [self updatePopoverButtonTitleAndHeaderLabel];
    [self loadData];
}



-(NSString*)popoverButtonTitle
{
    return self.navAction.name;
}



-(void)popoverSelector :(UIBarButtonItem *)sender
{
    
    [self showNavigationTableFromButton:self.navButtons[kPopoverButtonindex] navAction:self.navAction andLogoutButton:NO];
    
}




-(void) updatePopoverButtonTitleAndHeaderLabel
{
    [self.navButtons[kPopoverButtonindex] setNewTitle:[self popoverButtonTitle]];
    [self updateHeaderLabel];
}



#pragma mark - Methods related to navigationBar buttons

-(void) setupNavigationBarAndBackgroundView
{
    self.bAddSegmentedBar = FALSE;
    self.navigationItem.rightBarButtonItem = nil;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
}


- (void)createNavigationBarButtons
{
    GGBarButtonItem *closeButton = [[GGBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackLKey", @"")
                                                                    image:nil
                                                                   target:self
                                                                   action:@selector(dismiss)];
    closeButton.isAccessibilityElement = YES;
    closeButton.accessibilityLabel = @"Back Button";
    
    GGBarButtonItem *popoverButton = [[GGBarButtonItem alloc] initWithTitle:[self popoverButtonTitle]
                                                                      image:[UIImage imageNamed:@"DownChevrons.png"]
                                                                     target:self
                                                                     action:@selector(popoverSelector:)];
    
    popoverButton.isAccessibilityElement = YES;
    popoverButton.accessibilityLabel = @"Popover Button";
    
    self.navButtons = @[closeButton,popoverButton];
    self.navigationItem.leftBarButtonItems = self.navButtons;
}

-(void) dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
