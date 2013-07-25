//
//  PopularChannelsForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 02/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "PopularChannelsForCategoryDataFetcher.h"
#import "VimondStore.h"
#import "ContentCategory.h"
#import "SearchResult.h"
#import "ContentPanelStore.h"
#import "Constants.h"



@implementation PopularChannelsForCategoryDataFetcher


- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    
    //Satish: API of content panel store called to obtain data. This API is non paged
    NSArray *popularEntities = [[VimondStore contentPanelStore] contentPanel:ContentPanelTypePopularChannels forCategory:self.sourceObject error:&error];
    

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
