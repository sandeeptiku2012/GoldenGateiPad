//
//  MyChannelsDataSource.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/1/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "MyChannelsDataFetcher.h"

#import "VimondStore.h"

@implementation MyChannelsDataFetcher

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
        onSuccess(channels, channels.count);
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
