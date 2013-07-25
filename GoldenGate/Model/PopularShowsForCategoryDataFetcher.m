//
//  PopularShowsForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 21/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "PopularShowsForCategoryDataFetcher.h"
#import "VimondStore.h"
#import "ContentCategory.h"
#import "SearchResult.h"
#import "ContentPanelStore.h"

@implementation PopularShowsForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    
    //Satish: API of content panel store called to obtain data. This API is non paged
    NSArray *popularEntities = [[VimondStore contentPanelStore] contentPanel:ContentPanelTypePopularShows forCategory:self.sourceObject error:&error];
    
    
    SearchResult *searchResult = [SearchResult new];
    searchResult.items = popularEntities;
    searchResult.totalCount = [popularEntities count];
    
    if (!error)
    {
        onSuccess(searchResult.items, searchResult.totalCount);
    }
    else
    {
        onError(error);
    }
}

-(BOOL)doesSupportPaging
{
    return NO;
}


@end
