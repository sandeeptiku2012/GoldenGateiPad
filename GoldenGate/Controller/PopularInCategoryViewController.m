//
//  PopularInCategoryViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 23/11/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "PopularInCategoryViewController.h"

#import "CellViewFactory.h"
#import "VideoCellView.h"
#import "ChannelCellView.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "MostSubscribedChannelsForCategoryDataFetcher.h"
#import "PopularVideosForCategoryDataFetcher.h"

#define kMaxPages 8

@interface PopularInCategoryViewController () {
    MostSubscribedChannelsForCategoryDataFetcher *_mostSubscribedChannelsForCategoryDataFetcher;
    PopularVideosForCategoryDataFetcher *_popularVideosForCategoryDataFetcher;
}

@property(strong, nonatomic) ContentCategory *category;

@end

@implementation PopularInCategoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
}

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super init]))
    {
        _mostSubscribedChannelsForCategoryDataFetcher = [MostSubscribedChannelsForCategoryDataFetcher new];
        _popularVideosForCategoryDataFetcher = [PopularVideosForCategoryDataFetcher new];
        
        self.navAction = navAction;
        
        CategoryAction *categoryAction = (CategoryAction *)navAction.parentAction;
        self.category = categoryAction.category;

        CellViewFactory *channelCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[ChannelCellView class]];
        PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:_mostSubscribedChannelsForCategoryDataFetcher];
        dataSource.sortBy = ProgramSortByChannelSubscribers;
        dataSource.maxNumberOfPages = kMaxPages;
        [self registerName:NSLocalizedString(@"ChannelsMostSubscribedLKey", @"")
                dataSource:dataSource
           cellViewFactory:channelCellFactory
         forGridAtPosition:GridPositionTop];
        
        CellViewFactory *videoCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[VideoCellView class]];
        PrefetchingDataSource *videoDataSource = [PrefetchingDataSource createWithDataFetcher:_popularVideosForCategoryDataFetcher];
        videoDataSource.sortBy = ProgramSortByViewDesc;
        videoDataSource.maxNumberOfPages = kMaxPages;
        [self registerName:NSLocalizedString(@"VideosMostWatchedLKey", @"")
                dataSource:videoDataSource
           cellViewFactory:videoCellFactory
         forGridAtPosition:GridPositionBottom];
    }

    return self;
}

- (NSString*)noContentStringForGridAtPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? NSLocalizedString(@"NoNewChannelsFoundLKey", @"") : NSLocalizedString(@"NoNewVideoFoundLKey", @"");
}

- (NSString *)contentLoadErrorStringForGridAtPosition:(GridPosition)gridPosition
{
    return NSLocalizedString(@"ErrorLoadingContentLKey", @"");
}

- (void)setCategory:(ContentCategory *)category
{
    _category = category;
    _mostSubscribedChannelsForCategoryDataFetcher.sourceObject = category;
    _popularVideosForCategoryDataFetcher.sourceObject   = category;
}

@end
