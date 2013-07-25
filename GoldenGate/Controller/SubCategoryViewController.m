//
//  SubCategoryViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/11/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "ContentCategory.h"
#import "NavAction.h"
#import "CellViewFactory.h"
#import "ChannelCellView.h"
#import "FeaturedChannelsForCategoryDataFetcher.h"
#import "CategoryAction.h"
#import "EditorsPickForCategoryDataFetcher.h"

@interface SubCategoryViewController ()

@property(strong, nonatomic) FeaturedChannelsForCategoryDataFetcher *channelsForCategoryDataFetcher;
@property(strong, nonatomic) EditorsPickForCategoryDataFetcher *editorsPickForCategoryDataFetcher;

@end

@implementation SubCategoryViewController

- (id)initWithNavAction:(NavAction *)navAction
{
    if ((self = [super init]))
    {
        _channelsForCategoryDataFetcher = [FeaturedChannelsForCategoryDataFetcher new];
        _editorsPickForCategoryDataFetcher = [EditorsPickForCategoryDataFetcher new];
        
        self.navAction = navAction;
        
        CategoryAction *categoryAction = (CategoryAction *)navAction.parentAction;
        self.category = categoryAction.category;
    
        CellViewFactory *channelCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeLargeTextBelow
                                                                                cellViewClass:[ChannelCellView class]];
        PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:_channelsForCategoryDataFetcher];
        dataSource.sortBy = ProgramSortByDateDesc;
        [self registerName:NSLocalizedString(@"FeaturedChannelsLKey", @"") dataSource:dataSource
           cellViewFactory:channelCellFactory
         forGridAtPosition:GridPositionTop];



        CellViewFactory *editorsPickCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeLargeTextRight
                                                                                    cellViewClass:[ChannelCellView class]];
        [self registerName:NSLocalizedString(@"EditorsPickLKey", @"")
                dataSource:[PrefetchingDataSource createWithDataFetcher:_editorsPickForCategoryDataFetcher]
           cellViewFactory:editorsPickCellFactory
         forGridAtPosition:GridPositionBottom];
    }
    
    return self;
}

- (NSString*)noContentStringForGridAtPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? NSLocalizedString(@"NoFeaturedChannelsLKey", @"") : NSLocalizedString(@"NoEditorsPickLKey", @"");
}

- (BOOL)shouldHidePageIndicatorForGridAtPosition:(GridPosition)position
{
    // The Editors pick grid never needs a paging indicator, hence the hiding.
    return position == GridPositionBottom;
}

- (void)setCategory:(ContentCategory *)category
{
    _category = category;
    _channelsForCategoryDataFetcher.sourceObject = category;
    _editorsPickForCategoryDataFetcher.sourceObject = category;
}

@end
