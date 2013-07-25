//
//  SearchExecutor.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResult;
@class SearchClient;
@class RestPlatform;
@class CategoryStore;

@interface SearchExecutor : NSObject

- (SearchResult *)findVideosWithSearchString:(NSString *)string pageNumber:(NSUInteger)pageNumber objectsPrPage:(NSUInteger)objectsPerPage error:(NSError **)error;
- (SearchResult *)findChannelsWithSearchString:(NSString *)string pageNumber:(NSUInteger)number objectsPrPage:(NSUInteger)page error:(NSError **)error;

// Function to search for shows which match the string
- (SearchResult *)findShowsWithSearchString:(NSString *)string pageNumber:(NSUInteger)number objectsPrPage:(NSUInteger)page error:(NSError **)error;

- (id)initWithSearchClient:(SearchClient *)searchClient categoryStore:(CategoryStore *)categoryStore platform:(RestPlatform *)platform;


@property (weak, readonly, nonatomic) SearchClient      *searchClient;
@property (weak, readonly, nonatomic) CategoryStore     *categoryStore;
@property (weak, readonly, nonatomic) RestPlatform      *platform;


@end
