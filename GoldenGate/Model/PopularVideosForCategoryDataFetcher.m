//
//  PopularVideosForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/30/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "PopularVideosForCategoryDataFetcher.h"

#import "ContentCategory.h"
#import "SearchResult.h"
#import "VideoStore.h"
#import "VimondStore.h"

@implementation PopularVideosForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    SearchResult *searchResult = [[VimondStore videoStore] popularVideosForCategory:self.sourceObject
                                                                          pageIndex:pageNumber
                                                                           pageSize:objectsPrPage
                                                                             sortBy:sortBy
                                                                              error:&error];
    if (!error)
    {
        onSuccess(searchResult.items, searchResult.totalCount);
    }
    else
    {
        onError(error);
    }
}


@end
