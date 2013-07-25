//
//  NewChannelsForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/15/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NewChannelsForCategoryDataFetcher.h"

#import "VimondStore.h"
#import "Channel.h"
#import "ContentCategory.h"
#import "SearchResult.h"

@implementation NewChannelsForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    SearchResult *searchResult = [[VimondStore channelStore] newChannelsForCategory:self.sourceObject
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
