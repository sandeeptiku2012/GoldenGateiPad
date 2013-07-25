//
//  SearchExecutor.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SearchExecutor.h"
#import "SearchResult.h"
#import "RestSearchAssetList.h"
#import "SearchClient.h"
#import "RestSearchAsset.h"
#import "RestSearchCategory.h"
#import "RestSearchCategoryList.h"
#import "RestPlatform.h"
#import "CategoryStore.h"
#import "Show.h"

@implementation SearchExecutor

- (id)initWithSearchClient:(SearchClient *)searchClient categoryStore:(CategoryStore *)categoryStore platform:(RestPlatform *)platform
{
    if ((self = [super init]))
    {
        _searchClient = searchClient;
        _categoryStore = categoryStore;
        _platform = platform;
    }

    return self;
}


- (SearchResult *)findVideosWithSearchString:(NSString *)string
                                  pageNumber:(NSUInteger)pageNumber
                               objectsPrPage:(NSUInteger)objectsPerPage
                                       error:(NSError **)error
{


    RestSearchAssetList *result = [_searchClient getAssetsForPlatform:_platform
                                                          subCategory:[[self.categoryStore rootCategoryID:error]stringValue]
                                                                query:nil
                                                                 sort:nil
                                                                start:[NSNumber numberWithUnsignedInteger:pageNumber]
                                                                 size:[NSNumber numberWithUnsignedInteger:objectsPerPage]
                                                                 text:string
                                                                error:error];
    NSMutableArray *videos = [NSMutableArray array];
    for (RestSearchAsset *asset in result.assets)
    {
        [videos addObject:[asset videoObject]];
    }

    SearchResult *r = [[SearchResult alloc] init];
    r.totalCount = [result.numberOfHits unsignedIntegerValue];
    r.items = videos;
    return r;
}

- (SearchResult *)findChannelsWithSearchString:(NSString *)string
                                    pageNumber:(NSUInteger)number
                                 objectsPrPage:(NSUInteger)page
                                         error:(NSError **)error
{
    RestSearchCategoryList *result = [_searchClient getCategoriesForPlatform:_platform
                                                                 subCategory:[[self.categoryStore rootCategoryID:error]stringValue]
                                                                       query:@"levelName:SHOW"
                                                                        sort:nil
                                                                       start:[NSNumber numberWithUnsignedInteger:number]
                                                                        size:[NSNumber numberWithUnsignedInteger:page]
                                                                        text:string
                                                                       error:error];
    NSMutableArray *channels = [NSMutableArray array];
    for (RestSearchCategory *category in result.categories)
    {
        Channel* channel = [category channelObject];
        if (channel) {
            [channels addObject:channel];
        }
    }

    SearchResult *searchResult = [[SearchResult alloc] init];
    // if page size is zero query is made to know the number of items
    if (page>0) {
        searchResult.totalCount = [channels count];
    }else{
        searchResult.totalCount = [result.numberOfHits unsignedIntegerValue];
    }
    searchResult.items = channels;
    return searchResult;
}



- (SearchResult *)findShowsWithSearchString:(NSString *)string
                                    pageNumber:(NSUInteger)number
                                 objectsPrPage:(NSUInteger)page
                                         error:(NSError **)error
{
    RestSearchCategoryList *result = [_searchClient getCategoriesForPlatform:_platform
                                                                 subCategory:[[self.categoryStore rootCategoryID:error]stringValue]
                                                                       query:@"levelName:SUB_SHOW"
                                                                        sort:nil
                                                                       start:[NSNumber numberWithUnsignedInteger:number]
                                                                        size:[NSNumber numberWithUnsignedInteger:page]
                                                                        text:string
                                                                       error:error];
    NSMutableArray *shows = [NSMutableArray array];
    for (RestSearchCategory *category in result.categories)
    {
        Show* show = [category showsObject];
        if (show) {
            [shows addObject:show];
        }
    }
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    // if page size is zero query is made to know the number of items
    if (page>0) {
        searchResult.totalCount = [shows count];
    }else{
        searchResult.totalCount = [result.numberOfHits unsignedIntegerValue];
    }
    searchResult.items = shows;
    return searchResult;
}

@end
