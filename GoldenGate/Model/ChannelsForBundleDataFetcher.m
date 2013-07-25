//
//  ChannelsForBundleDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ChannelsForBundleDataFetcher.h"
#import "Bundle.h"
#import "ContentCategory.h"
#import "SearchResult.h"
#import "VimondStore.h"
#import "BundleStore.h"

@implementation ChannelsForBundleDataFetcher
- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [Bundle class]);
    
    NSError *error;
    SearchResult *channels = [[VimondStore bundleStore] channelsForBundle:self.sourceObject pageIndex:pageNumber pageSize:objectsPrPage sortBy:sortBy error:&error];
    

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
