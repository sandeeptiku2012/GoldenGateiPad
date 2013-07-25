//
//  PopularEntitiesForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "PopularEntitiesForCategoryDataFetcher.h"
#import "VimondStore.h"
#import "ContentCategory.h"
#import "SearchResult.h"
#import "ContentPanelStore.h"

@implementation PopularEntitiesForCategoryDataFetcher

-(id)init
{
    if ((self = [super init]))
    {
        self.strFilterBy = nil;
    }
    return self;
}

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    
    //Satish: API of content panel store called to obtain data. This API is non paged
    //Satish TBD: No API known to get mixture of popular channels and shows. Now fetching popular channels 
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
