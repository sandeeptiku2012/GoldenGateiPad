//
//  ShowsFromPublisherDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 17/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowsFromPublisherDataFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"

@implementation ShowsFromPublisherDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [NSString class]);
    
    NSError *error;
    SearchResult *shows = [[VimondStore showStore] showsFromPublisher:self.sourceObject
                                                                     pageIndex:pageNumber
                                                                      pageSize:objectsPrPage
                                                                        sortBy:sortBy
                                                                         error:&error];
    if (!error)
    {
        onSuccess(shows.items, shows.totalCount);
    }
    else
    {
        onError(error);
    }
}

@end