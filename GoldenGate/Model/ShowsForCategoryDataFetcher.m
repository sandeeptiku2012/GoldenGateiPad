//
//  ShowsForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 17/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowsForCategoryDataFetcher.h"

#import "VimondStore.h"
#import "Channel.h"
#import "ContentCategory.h"
#import "SearchResult.h"

@implementation ShowsForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    SearchResult *searchResult = [[VimondStore showStore] showsForCategory:self.sourceObject
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
