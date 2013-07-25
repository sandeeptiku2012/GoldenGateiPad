//
//  FeaturedChannelsForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FeaturedChannelsForCategoryDataFetcher.h"

#import "ContentCategory.h"
#import "SearchResult.h"
#import "VimondStore.h"
#import "ContentPanelStore.h"
#import "Constants.h"

@implementation FeaturedChannelsForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);

    NSError *error = nil;
    //Satish TBD: Featured now returns mix of bundles, channels, shows and episodes. Need to deprecate this fetcher once servers
    //fully migrated
    NSArray *featuredChannels = [[VimondStore contentPanelStore] contentPanel:ContentPanelTypeFeatured forCategory:self.sourceObject error:&error];

    SearchResult *searchResult = nil;
    
    BOOL shouldFallBackToNewChannels = featuredChannels.count == 0;
    if (shouldFallBackToNewChannels)
    {
        searchResult = [[VimondStore channelStore] channelsForCategory:self.sourceObject
                                                             pageIndex:pageNumber
                                                              pageSize:objectsPrPage
                                                                sortBy:sortBy
                                                                 error:&error];
    }
    else
    {
        searchResult = [SearchResult new];
        searchResult.items = featuredChannels;
        searchResult.totalCount = featuredChannels.count;
    }
    
    if (!error)
    {
        onSuccess(searchResult.items, searchResult.totalCount);
    }
    else
    {
        onError(error);
    }
}

- (BOOL)doesSupportPaging
{
    return NO;
}

@end
