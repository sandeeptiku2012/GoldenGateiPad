//
//  SearchResultFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/5/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SearchResultFetcher.h"
#import "SearchResult.h"

@interface SearchResultFetcher ()

- (SearchResult *)executeSearchWithSearchString:(NSString *)string
                                     pageNumber:(NSUInteger)pageNumber
                                  objectsPrPage:(NSUInteger)objectsPrPage
                                          error:(NSError**)error;

@end

@implementation SearchResultFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [NSString class]);

    NSString *searchString = self.sourceObject;
    SearchResult *searchResult = nil;
    NSError* error = nil;
    if (searchString.length > 0)
    {
        
        searchResult = [self executeSearchWithSearchString:searchString
                                                pageNumber:pageNumber
                                             objectsPrPage:objectsPrPage
                                                     error:&error];
    }
    
    if (!error)
    {
        if (onSuccess)
        {
            onSuccess(searchResult.items, searchResult.totalCount);
        }
    }
    else
    {
        if (onError)
        {
            onError(error);
        }
    }
}

- (SearchResult *)executeSearchWithSearchString:(NSString *)string
                                     pageNumber:(NSUInteger)pageNumber
                                  objectsPrPage:(NSUInteger)objectsPrPage
                                          error:(NSError**)error
{
    NSAssert(NO, @"Please re-implement in subclasses");
    return nil;
}

- (NSString *)buildSearchQueryFromString:(NSString *)string pageNumber:(NSUInteger)number objectsPrPage:(NSUInteger)page
{
    // Subclasses should re-implement this method
    return nil;
}

@end
