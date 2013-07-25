//
//  MyShowsDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "MyShowsDataFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"

@implementation MyShowsDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    NSError *error;
    NSArray *channels = [[VimondStore sharedStore] myChannels:&error];

    
    if (!error)
    {
        if (channels&&([channels count]>0)) {
            
            SearchResult *searchResult = [[VimondStore showStore] showsForChannels:channels contentCategory:self.sourceObject pageIndex:pageNumber pageSize:objectsPrPage sortBy:ProgramSortByAssetTitleAsc error:&error];

             onSuccess(searchResult.items, searchResult.totalCount);
            
            
        }else{
            onSuccess(nil, 0);
        }
        
    }
    else
    {
        onError(error);
    }
}




@end
