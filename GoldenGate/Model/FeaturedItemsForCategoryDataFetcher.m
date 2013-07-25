//
//  FeaturedItemsForCategory.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 04/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "FeaturedItemsForCategoryDataFetcher.h"
#import "VimondStore.h"
#import "ContentCategory.h"
#import "SearchResult.h"
#import "ContentPanelStore.h"

@implementation FeaturedItemsForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    KITAssertIsKindOfClass(self.sourceObject, [ContentCategory class]);
    
    NSError *error = nil;
    
    // API called to get featured items
    NSArray *featuredItems =[[VimondStore contentPanelStore] featuredContentPanelForCategory:self.sourceObject error:&error];
    
    SearchResult *searchResult = [SearchResult new];
    searchResult.items = featuredItems;
    searchResult.totalCount = [featuredItems count];
    
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
