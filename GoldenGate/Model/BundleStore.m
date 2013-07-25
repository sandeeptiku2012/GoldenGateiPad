//
//  BundleStore.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "BundleStore.h"
#import "VimondStore.h"
#import "TreeNodeCache.h"
#import "RestPlatform.h"
#import "Bundle.h"
#import "SearchResult.h"
#import "SearchClient.h"
#import "ProductGroupClient.h"
#import "RestProductGroup.h"
#import "RestSearchCategoryList.h"
#import "RestCategory.h"
#import "RestSearchCategory.h"
#import "RestProgramSortBy.h"
#import "ContentCategory.h"


@interface BundleStore ()
{
    RestPlatform *_platform;
    ProductGroupClient *_prodgroupClient;
    SearchClient *_searchClient;
   
}

@property (strong) TreeNodeCache *bundleCache;



@end

@implementation BundleStore


- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform = [RestPlatform platformWithName:platformName];
        _searchClient = [[SearchClient alloc] initWithBaseURL:baseURL];
        _prodgroupClient = [[ProductGroupClient alloc] initWithBaseURL:baseURL];
        _bundleCache = [TreeNodeCache new];
        _bundleCache.overrideOldNodes = YES;
        
    }
    
    return self;
    
}

- (Bundle *)bundleWithId:(NSUInteger)bundleId error:(NSError **)error
{
    Bundle *foundBundle = [self.bundleCache nodeWithKey:@(bundleId)];
    
    if (foundBundle == nil)
    {
        NSString* strExpand = @"metadata,products";
        NSError* error = nil;
        RestProductGroup* prodGroup =  [_prodgroupClient productGroupWithId:[NSNumber numberWithInt:bundleId] platform:_platform expand:strExpand error:&error];
        foundBundle = [prodGroup bundleObject];
        [self storeBundleInCache:foundBundle];
    }
    
    return foundBundle;
}


- (SearchResult *)channelsForBundle:(Bundle *)bundle pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error
{
    SearchResult *channelResult = nil;
    ContentCategory *contentCategory = [[VimondStore categoryStore] rootCategory:error];
    if (nil!=contentCategory) {
        NSString* categoryId = [NSString stringWithFormat:@"%d", contentCategory.identifier];
        RestProgramSortBy *sort = sortBy != ProgramSortByDefault ? [[RestProgramSortBy alloc] initWithEnum:sortBy] : nil;
        NSNumber *start = [NSNumber numberWithUnsignedInteger:pageIndex];
        NSNumber *size = [NSNumber numberWithUnsignedInteger:pageSize];
        NSString *queryString = [NSString stringWithFormat:@"prodGroupId:%d", bundle.identifier];
        
        channelResult = [self channelsForBundleWithCategory:categoryId query:queryString text:nil start:start size:size sort:sort error:error];
    }

    return channelResult;
}



- (SearchResult *)channelsForBundleWithCategory:(NSString *)categoryId query:(NSString *)query text:(NSString *)text start:(NSNumber *)start size:(NSNumber *)size sort:(RestProgramSortBy *)sort error:(NSError **)error
{
    RestSearchCategoryList *searchCategoryList = [_searchClient getCategoriesForPlatform:_platform
                                                                             subCategory:categoryId
                                                                                   query:query
                                                                                    sort:sort
                                                                                   start:start
                                                                                    size:size
                                                                                    text:text
                                                                                   error:error];
    
    NSMutableArray *channels = [NSMutableArray array];
    for (RestSearchCategory *searchCategory in searchCategoryList.categories)
    {
        // getting the channel object
        Channel* channel = [searchCategory channelObject];
        if (channel) {
            [channels addObject:channel];
        }
        
    }
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    // if size is zero query is made to know the number of items
    if ([size integerValue]>0) {
        searchResult.totalCount = [channels count];
    }else{
        searchResult.totalCount = [searchCategoryList.numberOfHits unsignedIntegerValue];
    }
    searchResult.items = channels;
    
    return searchResult;
}




// Caching
- (void)clearCache
{
     [_bundleCache clearCache];
}

- (void)storeBundleInCache:(Bundle *)bundle
{
    [self.bundleCache storeNode:bundle withKey:@(bundle.identifier)];
}

- (void)invalidateCacheForBundle:(Bundle *)bundle
{
     [self.bundleCache deleteNodeWithKey:@(bundle.identifier)];
}

@end
