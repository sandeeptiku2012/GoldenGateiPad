//
//  ChannelsForCategoryDataSource.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/2/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NewVideosForCategoryDataFetcher.h"

#import "VimondStore.h"
#import "Channel.h"
#import "ContentCategory.h"
#import "SearchResult.h"

@implementation NewVideosForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);

    NSError *error = nil;
    SearchResult *searchResult = [[VimondStore videoStore] newVideosForCategory:self.sourceObject
                                                                      pageIndex:pageNumber
                                                                       pageSize:objectsPrPage
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
