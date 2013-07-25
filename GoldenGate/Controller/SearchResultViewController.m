//
//  SearchResultViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SearchResultViewController.h"

#import "GlobalSearchModel.h"
#import "CellViewFactory.h"
#import "ChannelCellView.h"
#import "VideoCellView.h"

@interface SearchResultViewController ()

@end


@implementation SearchResultViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self registerName:NSLocalizedString(@"ChannelsLKey", @"")
                dataSource:[[GlobalSearchModel sharedInstance]fullSearchDataSourceForSearchScope:SearchScopeChannels]
           cellViewFactory:[[CellViewFactory alloc]initWithWantedCellSize:CellSizeSmall cellViewClass:[ChannelCellView class]]
         forGridAtPosition:GridPositionTop];
        
        [self registerName:NSLocalizedString(@"VideosLKey", @"")
                dataSource:[[GlobalSearchModel sharedInstance]fullSearchDataSourceForSearchScope:SearchScopeVideos]
           cellViewFactory:[[CellViewFactory alloc]initWithWantedCellSize:CellSizeSmall cellViewClass:[VideoCellView class]]
         forGridAtPosition:GridPositionBottom];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SearchResultsLKey", @"");
}

- (BOOL)shouldReloadGridsOnViewDidLoad
{
    return NO;
}

- (void)executeSearchWithString:(NSString*)searchString
                    searchScope:(SearchScope)searchScope
                   gridPosition:(GridPosition)gridPosition
{
    [self showLoadingIndicatorWithMessage:NSLocalizedString(@"SearchingLKey", @"") forGridAtPosition:gridPosition];
    [[GlobalSearchModel sharedInstance]executeFullSearchWithString:searchString
                                                    forSearchScope:searchScope
                                                    successHandler:^(NSUInteger totalObjectCount)
    {
        [self reloadGridAtPosition:gridPosition];
    }
    errorHandler:^(NSError *error)
    {
        [self showRetryWithMessage:NSLocalizedString(@"SearchErrorLKey", @"") forGridAtPosition:gridPosition];
    }];
}

- (void)executeVideoSearchWithString:(NSString *)searchString
{
    [self executeSearchWithString:searchString searchScope:SearchScopeVideos gridPosition:GridPositionBottom];
}

- (void)executeChannelSearchWithString:(NSString *)searchString
{
    [self executeSearchWithString:searchString searchScope:SearchScopeChannels gridPosition:GridPositionTop];
}

- (void)executeSearchWithSearchString:(NSString*)searchString
{
    [self executeVideoSearchWithString:searchString];
    [self executeChannelSearchWithString:searchString];
}

- (void)retryButtonPressedForGridAtPosition:(GridPosition)gridPosition
{
    NSString *searchString = [GlobalSearchModel sharedInstance].lastUsedSearchString;
    if (gridPosition == GridPositionTop)
    {
        [self executeChannelSearchWithString:searchString];
    }
    else
    {
        [self executeVideoSearchWithString:searchString];
    }
}

- (NSString*)noContentStringForGridAtPosition:(GridPosition)gridPosition
{
    return gridPosition == GridPositionTop ? NSLocalizedString(@"NoSearchMatchFoundChannelsLKey", @"") : NSLocalizedString(@"NoSearchMatchFoundVideosLKey", @"") ;
}

- (NSString *)contentLoadErrorStringForGridAtPosition:(GridPosition)gridPosition
{
    return NSLocalizedString(@"SearchErrorLKey", @"");
}

@end
