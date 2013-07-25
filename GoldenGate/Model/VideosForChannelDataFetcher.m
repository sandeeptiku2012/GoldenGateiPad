//
//  VideosForChannelDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VideosForChannelDataFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"
#import "Channel.h"


@implementation VideosForChannelDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [Channel class]);

    NSError *error;
    SearchResult *videos = [[VimondStore videoStore] videosForChannel:self.sourceObject
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
