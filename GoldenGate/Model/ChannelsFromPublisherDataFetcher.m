//
//  ChannelsFromPublisherDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/29/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ChannelsFromPublisherDataFetcher.h"
#import "VimondStore.h"
#import "SearchResult.h"

@implementation ChannelsFromPublisherDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [NSString class]);

    NSError *error;
    SearchResult *channels = [[VimondStore channelStore] channelsFromPublisher:self.sourceObject
                                                                     pageIndex:pageNumber
                                                                      pageSize:objectsPrPage
                                                                        sortBy:sortBy
                                                                         error:&error];
    if (!error)
    {
        onSuccess(channels.items, channels.totalCount);
    }
    else
    {
        onError(error);
    }
}

@end
