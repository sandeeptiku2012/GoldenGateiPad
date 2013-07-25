//
//  ShowStore.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowStore.h"
#import "SearchResult.h"
#import "ContentCategory.h"
#import "SearchClient.h"
#import "RestPlatform.h"
#import "RestSearchCategoryList.h"
#import "RestSearchCategory.h"
#import "Show.h"
#import "VimondStore.h"
#import "TreeNodeCache.h"
#import "Channel.h"
#import "SearchClient.h"

@interface ShowStore()
{
RestPlatform *_platform;
SearchClient *_searchClient;
}

@property (strong) TreeNodeCache *showsCache;
@end


@implementation ShowStore


- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform = [RestPlatform platformWithName:platformName];
        _searchClient = [[SearchClient alloc] initWithBaseURL:baseURL];
        _showsCache = [TreeNodeCache new];
        _showsCache.overrideOldNodes = YES;
    }
    
    return self;
}

- (void)clearCache
{
    [_showsCache clearCache];
}

- (void)storeShowInCache:(Show *)show
{
    [self.showsCache storeNode:show withKey:@(show.identifier)];
}

- (void)invalidateCacheForShow:(Show *)show
{
    [self.showsCache deleteNodeWithKey:@(show.identifier)];
}


- (Show *)showWithId:(NSUInteger)showId error:(NSError **)error
{
    Show *foundShow = [self.showsCache nodeWithKey:@(showId)];
    
    if (foundShow == nil)
    {
        NSString *query = [NSString stringWithFormat:@"categoryId:%d", showId];
        NSString *categoryId = [[[VimondStore categoryStore] rootCategoryID:error] stringValue];
        SearchResult *result = [self showsForCategory:categoryId query:query sort:nil start:@0 size:@1 text:nil error:error];
        if (result.totalCount > 0)
        {
            foundShow = [result.items objectAtIndex:0];
        }
    }
    
    return foundShow;
}




- (SearchResult *)showsForCategory:(ContentCategory *)category
                         pageIndex:(NSUInteger)pageIndex
                          pageSize:(NSUInteger)pageSize
                            sortBy:(ProgramSortBy)sortBy
                             error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
    NSNumber *start = [NSNumber numberWithUnsignedInteger:pageIndex];
    NSNumber *size = [NSNumber numberWithUnsignedInteger:pageSize];
    
    SearchResult *channelResult = [self showsForCategory:categoryId query:@"levelName:SUB_SHOW" sort:sort start:start size:size text:nil error:error];
    return channelResult;
}


- (SearchResult *)showsForCategory:(NSString *)categoryId
                             query:(NSString *)query
                              sort:(RestProgramSortBy *)sort
                             start:(NSNumber *)start
                              size:(NSNumber *)size
                              text:(NSString *)text
                             error:(NSError **)error
{
    RestSearchCategoryList *searchCategoryList = [_searchClient getCategoriesForPlatform:_platform
                                                                             subCategory:categoryId
                                                                                   query:query
                                                                                    sort:sort
                                                                                   start:start
                                                                                    size:size
                                                                                    text:text
                                                                                   error:error];
    NSMutableArray *shows = [NSMutableArray array];
    for (RestSearchCategory *searchCategory in searchCategoryList.categories)
    {
        // obtain the show object
        Show* show = [searchCategory showsObject];
        if (show) {
            [shows addObject:show];
        }
        
    }
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    // if size is zero query is made to know the number of items
    if ([size integerValue]>0) {
        searchResult.totalCount = [shows count];
    }else{
        searchResult.totalCount = [searchCategoryList.numberOfHits unsignedIntegerValue];
    }
    searchResult.items = shows;
    
    for (Show *show in shows)
    {
        [self storeShowInCache:show];
    }
    
    
    return searchResult;
}


- (SearchResult *)showsForChannels:(NSArray*)channels
                   contentCategory: (ContentCategory *)category
                         pageIndex:(NSUInteger)pageIndex
                          pageSize:(NSUInteger)pageSize
                            sortBy:(ProgramSortBy)sortBy
                             error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", category.identifier];
    RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
    NSNumber *start = [NSNumber numberWithUnsignedInteger:pageIndex];
    NSNumber *size = [NSNumber numberWithUnsignedInteger:pageSize];
    NSMutableString* queryString = nil;
    
    for (Channel* channel in channels) {
        if (nil == queryString) {
            queryString = [NSMutableString new];
            [queryString appendString:@"("];
        }else{
            [queryString appendString:@" OR "];
        }
        [queryString appendFormat:@"(parentCategoryId:%d)", channel.identifier];
    }
    if (nil!=queryString) {
        [queryString appendString:@") AND levelName:SUB_SHOW"];
    }
    
    SearchResult *showsResult = [self showsForChannels:categoryId query:queryString sort:sort start:start size:size text:nil error:error];
    return showsResult;
}


- (SearchResult *)showsForChannels:(NSString *)categoryId
                             query:(NSString *)query
                              sort:(RestProgramSortBy *)sort
                             start:(NSNumber *)start
                              size:(NSNumber *)size
                              text:(NSString *)text
                             error:(NSError **)error
{
    RestSearchCategoryList *searchCategoryList = [_searchClient getCategoriesForPlatform:_platform
                                                                             subCategory:categoryId
                                                                                   query:query
                                                                                    sort:sort
                                                                                   start:start
                                                                                    size:size
                                                                                    text:text
                                                                                   error:error];
    NSMutableArray *shows = [NSMutableArray array];
    for (RestSearchCategory *searchCategory in searchCategoryList.categories)
    {
        Show* show = [searchCategory showsObject];
        if (show) {
            [shows addObject:show];
        }
        
    }
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    // if size is zero query is made to know the number of items
    if ([size integerValue]>0) {
        searchResult.totalCount = [shows count];
    }else{
        searchResult.totalCount = [searchCategoryList.numberOfHits unsignedIntegerValue];
    }
    
    searchResult.items = shows;
    
    // show added to cache
    for (Show *show in shows)
    {
        [self storeShowInCache:show];
    }
    
    return searchResult;
}


- (SearchResult *)showsFromPublisher:(NSString *)publisher pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sort error:(NSError **)error
{
    NSString *rootCategoryId = [[[VimondStore categoryStore] rootCategoryID:error] stringValue];
    NSString *query = [NSString stringWithFormat:@"levelName:SUB_SHOW AND categoryMeta_publisher_text:\"%@\"", [publisher stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    RestProgramSortBy *restProgramSortBy = sort != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sort] : nil;
    return [self showsForCategory:rootCategoryId
                            query:query
                             sort:restProgramSortBy
                            start:[NSNumber numberWithUnsignedInteger:pageIndex]
                             size:[NSNumber numberWithUnsignedInteger:pageSize]
                             text:nil error:error];
}



- (NSUInteger)numberOfEpisodesInShow:(Show *)show error:(NSError **)error
{
    NSString *categoryId = [NSString stringWithFormat:@"%d", show.identifier];
    SearchResult *result = [self showsForCategory:categoryId query:nil sort:nil start:@0 size:@0 text:nil error:error];
    return result.totalCount;
}



@end
