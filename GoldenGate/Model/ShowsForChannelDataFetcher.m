//
//  ShowsForChannelDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowsForChannelDataFetcher.h"
#import "SearchResult.h"
#import "VimondStore.h"
#import "Channel.h"

@implementation ShowsForChannelDataFetcher
- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [Channel class]);
    
    
    
    NSError *error;
    ContentCategory* category = [[VimondStore categoryStore] rootCategory:&error];
    SearchResult *searchResult = nil;
    if (nil!=category) {
        NSArray* arrayChannels = [[NSArray alloc]initWithObjects:self.sourceObject, nil];
        searchResult = [[VimondStore showStore] showsForChannels:arrayChannels contentCategory:category pageIndex:pageNumber pageSize:objectsPrPage sortBy:sortBy error:&error];
    }
  
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
