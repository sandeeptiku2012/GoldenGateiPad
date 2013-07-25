//
//  NewInCategoryViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/9/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NewInCategoryViewController.h"

#import "CellViewFactory.h"
#import "VideoCellView.h"
#import "ChannelCellView.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "NewChannelsForCategoryDataFetcher.h"
#import "NewVideosForCategoryDataFetcher.h"

@interface NewInCategoryViewController () {
    NewChannelsForCategoryDataFetcher *_channelsForCategoryDataFetcher;
    NewVideosForCategoryDataFetcher *_videosForCategoryDataFetcher;
}

@property(strong, nonatomic) ContentCategory *category;

@end

@implementation NewInCategoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
}

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super init]))
    {
        _channelsForCategoryDataFetcher = [NewChannelsForCategoryDataFetcher new];
        _videosForCategoryDataFetcher   = [NewVideosForCategoryDataFetcher new];
        
        self.navAction = navAction;
        
        CategoryAction *categoryAction = (CategoryAction *)navAction.parentAction;
        self.category = categoryAction.category;

        CellViewFactory *channelCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[ChannelCellView class]];
        PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:_channelsForCategoryDataFetcher];
        dataSource.sortBy = ProgramSortByDateDesc;
        [self registerName:NSLocalizedString(@"ChannelsWithNewContentLKey", @"")
                dataSource:dataSource
           cellViewFactory:channelCellFactory
         forGridAtPosition:GridPositionTop];
        
        CellViewFactory *videoCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[VideoCellView class]];
        PrefetchingDataSource *videoDataSource = [PrefetchingDataSource createWithDataFetcher:_videosForCategoryDataFetcher];
        videoDataSource.sortBy = ProgramSortByPublishedDateDesc;
        [self registerName:NSLocalizedString(@"NewVideosLKey", @"")
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
    _channelsForCategoryDataFetcher.sourceObject = category;
    _videosForCategoryDataFetcher.sourceObject   = category;
}

@end
