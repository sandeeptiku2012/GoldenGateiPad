//
//  GlobalSearchModel.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/5/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GlobalSearchModel.h"
#import "PrefetchingDataSource.h"
#import "SearchResultFetcher.h"
#import "VideoSearchResultFetcher.h"
#import "ChannelSearchResultFetcher.h"
#import "ShowSearchResultFetcher.h"

#define kLastUsedSearchScopeKey @"lastUsedSearchScope"
#define kDefaultPreviewSearchObjectsPrPage 5
#define kDefaultFullSearchObjectsPrPage 12

@interface GlobalSearchModel()

// Map from search mode to SearchResultFetcher
@property (strong, nonatomic) NSMutableDictionary *searchScopeToPreviewSearchDataSourceDict;
@property (strong, nonatomic) NSMutableDictionary *searchScopeToFullSearchDataSourceDict;

- (SearchScope)lastUsedSearchScope;

@end

@implementation GlobalSearchModel

+ (GlobalSearchModel *)sharedInstance
{
    static GlobalSearchModel *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.previewSearchObjectsPrPage = kDefaultPreviewSearchObjectsPrPage;
        self.fullSearchObjectsPrPage = kDefaultFullSearchObjectsPrPage;

        self.searchScopeToFullSearchDataSourceDict      = [NSMutableDictionary new];
        self.searchScopeToPreviewSearchDataSourceDict   = [NSMutableDictionary new];

        [self registerSearchResultFetcherClass:[ChannelSearchResultFetcher class] forSearchScope:SearchScopeChannels];
        [self registerSearchResultFetcherClass:[VideoSearchResultFetcher class] forSearchScope:SearchScopeVideos];
        [self registerSearchResultFetcherClass:[ShowSearchResultFetcher class] forSearchScope:SearchScopeShows];

        // Restore last used search mode from stored user preferences
        self.currentSearchBarSearchScope = [self lastUsedSearchScope];
    }

    return self;
}

#pragma mark - Public methods

- (PrefetchingDataSource *)fullSearchDataSourceForSearchScope:(SearchScope)searchScope
{
    return [self.searchScopeToFullSearchDataSourceDict objectForKey:@(searchScope)];
}

- (PrefetchingDataSource *)previewSearchDataSourceForSearchScope:(SearchScope)searchScope
{
    return [self.searchScopeToPreviewSearchDataSourceDict objectForKey:@(searchScope)];
}

- (void)executeSearchWithString:(NSString*)searchString
                     dataSource:(PrefetchingDataSource*)dataSource
                 successHandler:(IntHandler)onSuccess
                   errorHandler:(ErrorHandler)onError
{
    _lastUsedSearchString = searchString;
    
    SearchResultFetcher *searchResultFetcher = (SearchResultFetcher *) dataSource.dataFetcher;
    searchResultFetcher.sourceObject = searchString;

    // This call will force the first page of the datasource to be populated, hence performing the search.
    [dataSource fetchDataObjectAtIndex:0
                                 successHandler:^(NSObject *dataObject)
     {
         if (onSuccess)
         {
             onSuccess(dataSource.cachedTotalItemCount);
         }
     } errorHandler:onError];
}

- (void)executePreviewSearchWithString:(NSString*)searchString
                        forSearchScope:(SearchScope)searchScope
                        successHandler:(IntHandler)onSuccess
                          errorHandler:(ErrorHandler)onError
{
    PrefetchingDataSource *dataSourceForSearch = [self previewSearchDataSourceForSearchScope:searchScope];
    [self executeSearchWithString:searchString dataSource:dataSourceForSearch successHandler:onSuccess errorHandler:onError];
    [self storeLastUsedSearchScope:searchScope];
}

- (void)executeFullSearchWithString:(NSString*)searchString
                     forSearchScope:(SearchScope)searchScope
                     successHandler:(IntHandler)onSuccess
                       errorHandler:(ErrorHandler)onError
{
    PrefetchingDataSource *dataSourceForSearch = [self fullSearchDataSourceForSearchScope:searchScope];
    [self executeSearchWithString:searchString dataSource:dataSourceForSearch successHandler:onSuccess errorHandler:onError];
}

#pragma mark - Private methods

- (void)registerSearchResultFetcherClass:(Class)dataFetcherClass forSearchScope:(SearchScope)searchScope
{
    NSAssert([dataFetcherClass isSubclassOfClass:[SearchResultFetcher class]], @"dataFetcherClass must be a subclass of SearchResultFetcher");

    // Create one data source for the preview searches and one for the full searches.
    PrefetchingDataSource *fullDataSource = [PrefetchingDataSource createWithDataFetcher:[dataFetcherClass new]];
    fullDataSource.objectsPrPage = self.fullSearchObjectsPrPage;
    [self.searchScopeToFullSearchDataSourceDict setObject:fullDataSource forKey:@(searchScope)];

    PrefetchingDataSource *previewDataSource = [PrefetchingDataSource createWithDataFetcher:[dataFetcherClass new]];
    previewDataSource.objectsPrPage = self.previewSearchObjectsPrPage;
    previewDataSource.pagesToPrefetchOnEachSide = 0; // Only prefetch one page for the previews
    [self.searchScopeToPreviewSearchDataSourceDict setObject:previewDataSource forKey:@(searchScope)];
}

- (PrefetchingDataSource *)findFullSearchDataSourceForScope:(SearchScope)searchScope
{
    return [self.searchScopeToFullSearchDataSourceDict objectForKey:@(searchScope)];
}

- (PrefetchingDataSource *)findPreviewSearchDataSourceForScope:(SearchScope)searchScope
{
    return [self.searchScopeToPreviewSearchDataSourceDict objectForKey:@(searchScope)];
}

- (SearchScope)lastUsedSearchScope
{
    NSNumber *lastUsedSearchScopeAsNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedSearchScopeKey];
    return (SearchScope) [lastUsedSearchScopeAsNumber intValue];
}

- (void)storeLastUsedSearchScope:(SearchScope)searchScope
{
    [[NSUserDefaults standardUserDefaults] setObject:@(searchScope) forKey:kLastUsedSearchScopeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
