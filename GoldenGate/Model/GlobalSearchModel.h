//
//  GlobalSearchModel.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/5/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlockDefinitions.h"

@class PrefetchingDataSource;

@interface GlobalSearchModel : NSObject

typedef enum
{
    SearchScopeChannels,
    SearchScopeShows,
    SearchScopeVideos
} SearchScope;

+ (GlobalSearchModel *)sharedInstance;

/*!
 @abstract The search scope currently set in the UISearchBar
 */
@property (assign, nonatomic) SearchScope currentSearchBarSearchScope;

- (PrefetchingDataSource *)fullSearchDataSourceForSearchScope:(SearchScope)searchScope;
- (PrefetchingDataSource *)previewSearchDataSourceForSearchScope:(SearchScope)searchScope;

/*!
 @abstract
 Updates the query string for the SearchResultFetcher for the given searchMode calls
 the successHandler when the search is done.
 This should be used when fetching full search result set.
 */
- (void)executeFullSearchWithString:(NSString*)searchString
                     forSearchScope:(SearchScope)searchScope
                     successHandler:(IntHandler)onSuccess
                       errorHandler:(ErrorHandler)onError;

/*!
 @abstract
 Updates the query string for the SearchResultFetcher for the given searchMode calls
 the successHandler when the search is done.
 This should be used when fetching search results for showing in the UISearchBar's popover
 */
- (void)executePreviewSearchWithString:(NSString*)searchString
                        forSearchScope:(SearchScope)searchScope
                        successHandler:(IntHandler)onSuccess
                          errorHandler:(ErrorHandler)onError;

/*!
 @abstract
 The number of objects to return pr page for preview searches.
 Preview searches are smaller than full searches and are used
 for populating search result tables as you type the search query.
 Default is 5
 */
@property (assign, nonatomic) NSUInteger previewSearchObjectsPrPage;

/*!
 @abstract
 The number of objects to return pr page for full searches.
 Default is 12
 */
@property (assign, nonatomic) NSUInteger fullSearchObjectsPrPage;

/*!
 @abstract
 Every time a search is performed this property is updated with the 
 search string that was used during that search.
 */
@property (copy, readonly) NSString *lastUsedSearchString;

@end
