//
//  EpisodesForShowDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 27/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "EpisodesForShowDataFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"
#import "Show.h"

@implementation EpisodesForShowDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [Show class]);
    
    NSError *error;
    SearchResult *videos = [[VimondStore videoStore] videosForShow:self.sourceObject
                                                            pageIndex:pageNumber
                                                             pageSize:objectsPrPage
                                                               sortBy:sortBy
                                                                error:&error];
    if (!error)
    {
        onSuccess(videos.items, videos.totalCount);
    }
    else
    {
        onError(error);
    }
}


@end
