//
//  FavoriteVideosDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/24/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoriteVideosDataFetcher.h"

#import "VimondStore.h"

@implementation FavoriteVideosDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    NSError *error;
    NSArray *videos = [[VimondStore favoriteStore] favoriteVideos:&error];

    if (!error)
    {
        onSuccess(videos, [videos count]);
    }
    else
    {
        onError(error);
    }
}

- (BOOL)doesSupportPaging
{
    return NO;
}

@end
