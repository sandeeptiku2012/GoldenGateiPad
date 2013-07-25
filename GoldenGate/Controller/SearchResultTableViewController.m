//
//  SearchResultTableViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SearchResultTableViewController.h"

#import "SearchResultCell.h"
#import "AllSearchResultsCell.h"
#import "KITTileImageView.h"
#import "GGColor.h"
#import "SearchResultInfoDelivering.h"
#import "PrefetchingDataSource.h"
#import "GlobalSearchModel.h"
#import "ChannelModalViewController.h"
#import "VideoPlaybackViewController.h"
#import "Channel.h"
#import "Video.h"

#define kMaxSearchResults 5

@interface SearchResultTableViewController ()

enum
{
    kSectionIndexAllResultsButton,
    kSectionIndexResults
};

typedef enum
{
    SearchResultTableModeShowResults,
    SearchResultTableModeShowLoading,
    SearchResultTableModeShowError
} SearchResultTableMode;

@property (strong, nonatomic) NSArray *searchResultArray; // Temp until datasource has been made.

@property (strong, nonatomic) GlobalSearchModel *globalSearchModel;

@property (assign) SearchResultTableMode searchResultTableMode;


@end

static NSString *cellID;
static NSString *allResultsCellID;

@implementation SearchResultTableViewController

+ (void)initialize
{
    if (cellID == nil)
    {
        cellID = NSStringFromClass([SearchResultCell class]);
    }
    
    if (allResultsCellID == nil)
    {
        allResultsCellID = NSStringFromClass([AllSearchResultsCell class]);
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.globalSearchModel = [GlobalSearchModel sharedInstance];

    [self setupTableView];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:allResultsCellID bundle:nil] forCellReuseIdentifier:allResultsCellID];
    self.tableView.bounces = NO;

    [self.tableView setBackgroundView:[[KITTileImageView alloc]initWithImage:[UIImage imageNamed:@"LightGrayNoiseBg.png"]]];
    self.tableView.separatorColor   = [GGColor lightGrayColor];
    self.tableView.tableFooterView  = [UIView new]; // Just an emtpy view here to stop repeating table separators.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)reloadTable
{
    [self.tableView reloadData];
}

- (void)showLoadingIndicator
{
    self.searchResultTableMode = SearchResultTableModeShowLoading;
    [self reloadTable];
}

- (void)showSearchResults
{
    self.searchResultTableMode = SearchResultTableModeShowResults;
    [self reloadTable];
}

- (void)showError
{
    self.searchResultTableMode = SearchResultTableModeShowError;
    [self reloadTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSectionIndexResults)
    {
        return self.searchResultTableMode == SearchResultTableModeShowResults ? MIN(kMaxSearchResults, [self currentDataSource].cachedTotalItemCount) : 0;
    }
    else
    {
        return 1;
    }
    
}

- (PrefetchingDataSource*)currentDataSource
{
    return [self.globalSearchModel previewSearchDataSourceForSearchScope:self.globalSearchModel.currentSearchBarSearchScope];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSectionIndexResults)
    {
        return [self searchResultCellForTableView:tableView atRow:indexPath.row];
    }
    else
    {
        return [self allResultsCellForTableView:tableView];
    }
}

- (UITableViewCell *)allResultsCellForTableView:(UITableView*)tableView
{
    AllSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:allResultsCellID];
    if (self.searchResultTableMode == SearchResultTableModeShowLoading)
    {
        [cell startSpinner];
       
    }
    else
    {
        [cell stopSpinner];
        NSString *cellText = nil;
        if (self.searchResultTableMode == SearchResultTableModeShowResults)
        {
            cellText = [self currentDataSource].cachedTotalItemCount > 0 ? NSLocalizedString(@"ShowAllResultsLKey", @"") : NSLocalizedString(@"NoSearchResultsLKey", @"");
            cell.accessibilityLabel=@"Show Result";
        }
        else
        {
            cellText = NSLocalizedString(@"SearchErrorLKey", @"");
            
            
        }
        
        cell.cellText = cellText;
        
    }
    
    return cell;
}

- (UITableViewCell *)searchResultCellForTableView:(UITableView*)tableView atRow:(NSInteger)row
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
     
    // This should be safe as long as there are so few cells visible, and all of the cells are visible
    // at the same time.
    // If for some reason this changes in the future this needs a robustification by adding
    // an index check.
    [[self currentDataSource] fetchDataObjectAtIndex:row successHandler:^(NSObject *dataObject)
    {
        id <SearchResultInfoDelivering> searchResultInfo = (id <SearchResultInfoDelivering>)dataObject;
        cell.upperLabelText = searchResultInfo.searchResultTitleText;
        cell.lowerLabelText = searchResultInfo.searchResultDetailText;
        
        float pixelScale = [UIScreen mainScreen].scale;
        CGSize sizeBasedOnPixelScale= CGSizeMake(cell.imageSize.width * pixelScale, cell.imageSize.height * pixelScale);
        cell.imageURL       = [searchResultInfo searchResultImageURLWithSize:sizeBasedOnPixelScale];
    } errorHandler:nil];


    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Post a notification to dismiss the search result popover when a result has been clicked.
   
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDismissSearchPopover object:nil];
    
    if (indexPath.section == kSectionIndexResults)
    {
        [[self currentDataSource] fetchDataObjectAtIndex:indexPath.row
                                          successHandler:^(NSObject *dataObject)
         {
             [self handleSearchResultTap:dataObject];
         } errorHandler:nil];
    }
    else if (indexPath.section == kSectionIndexAllResultsButton)
    {
         
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationShowAllSearchResults
                                                           object:nil];
       
    }
}

- (void)handleSearchResultTap:(NSObject*)tappedObject
{
    if ([tappedObject isKindOfClass:[Channel class]])
    {
        [ChannelModalViewController showFromView:nil withChannel:(Channel*)tappedObject navController:self.mainNavigationController];
    }
    else if ([tappedObject isKindOfClass:[Video class]])
    {
        [VideoPlaybackViewController presentVideo:(Video*)tappedObject fromChannel:nil withNavigationController:self.mainNavigationController];
    }
}

@end
