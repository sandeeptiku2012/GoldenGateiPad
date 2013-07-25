//
//  ShowsSubscriptionsViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowsSubscriptionsViewController.h"
#import "ShowSummaryCellPaged.h"
#import "MyShowsDataFetcher.h"
#import "PrefetchingDataSource.h"
#import "CategoryAction.h"
#import "MyChannelsAction.h"
#import "ChannelsForCategoryDataFetcher.h"


#define kNumberOfRowsPrPage 4

@interface ShowsSubscriptionsViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) PrefetchingDataSource *prefetchingDataSource;
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;
@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UILabel *tableHeaderLabel;

@property(strong, nonatomic) ShowSummaryCellPaged *prototypeCell;

@property(weak, nonatomic) ContentCategory *category;

@property (strong, nonatomic) NSMutableDictionary *alternateColorDict;
@end

static NSString *cellID;

@implementation ShowsSubscriptionsViewController
+ (void)initialize
{
    if (cellID == nil)
    {
        cellID = NSStringFromClass([ShowSummaryCellPaged class]);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingView.delegate = self;
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
    return self.category ? NSLocalizedString(@"CategoryHasNoShowsLKey", @"") : NSLocalizedString(@"UserHasNoShowsLKey", @"");
}


- (PrefetchingDataSource *)createPrefetchingDataSource
{
    PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:[MyShowsDataFetcher new]];
    dataSource.sortBy = ProgramSortByCategoryNameAsc;
    dataSource.objectsPrPage = kNumberOfRowsPrPage;
    return dataSource;
}

- (void)updateHeaderLabel
{
    NSString *labelText = NSLocalizedString(@"SubscriptionsLKey", @"");
    if (self.category)
    {
        labelText = [NSString stringWithFormat:NSLocalizedString(@"AllOfCategoryLKey", @""), self.navAction.parentAction.name];
    }
    
    self.tableHeaderLabel.text = labelText;
}

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
    ShowSummaryCellPaged *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.navController = [self getNavControllerForView];
    
    [self.prefetchingDataSource fetchDataObjectAtIndex:indexPath.row
                                        successHandler:^(NSObject *dataObject)
     {

         cell.show = (Show*)dataObject;
         
         NSLog(@"Show title %@", cell.show);
     } errorHandler:nil];
    
    return cell;
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self loadData];
}

#pragma mark - Properties

- (ShowSummaryCellPaged *)prototypeCell
{
    if (_prototypeCell == nil)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return _prototypeCell;
}




@end
