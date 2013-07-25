//
//  NewVideosForUserDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NewVideosForUserDataFetcher.h"

#import "VimondStore.h"
#import "SearchResult.h"

@implementation NewVideosForUserDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber objectsPrPage:(NSUInteger)objectsPrPage sortBy:(ProgramSortBy)sortBy successHandler:(PagedObjectsHandler)onSuccess errorHandler:(ErrorHandler)onError
{
    NSError *error = nil;
    SearchResult *videos = [[VimondStore sharedStore] myNewVideos:pageNumber objectsPerPage:objectsPrPage error:&error];

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
