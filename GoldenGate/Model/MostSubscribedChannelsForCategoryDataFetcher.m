//
//  Created by Andreas Petrov on 11/30/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "MostSubscribedChannelsForCategoryDataFetcher.h"
#import "SearchResult.h"
#import "VimondStore.h"
#import "ContentCategory.h"


@implementation MostSubscribedChannelsForCategoryDataFetcher
{

}

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);

    NSError *error = nil;
    SearchResult *searchResult = [[VimondStore channelStore] mostSubscribedChannelsForCategory:self.sourceObject
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