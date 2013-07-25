//
//  ShowStore.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestProgramSortBy.h"

@class SearchResult;
@class ContentCategory;
@class Show;


@interface ShowStore : NSObject


- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

// Function to obtain shows in a Category
- (SearchResult *)showsForCategory:(ContentCategory *)category
                            pageIndex:(NSUInteger)pageIndex
                             pageSize:(NSUInteger)pageSize
                               sortBy:(ProgramSortBy)sortBy
                                error:(NSError **)error;

- (Show *)showWithId:(NSUInteger)showId error:(NSError **)error;
- (NSUInteger)numberOfEpisodesInShow:(Show *)show error:(NSError **)error;



// Function to obtain shows for channels. Channels are passed in as array
// if many functions for shows need to be added, the following function to be moved to ShowStore class
- (SearchResult *)showsForChannels:(NSArray*)channels
                   contentCategory: (ContentCategory *)category
                         pageIndex:(NSUInteger)pageIndex
                          pageSize:(NSUInteger)pageSize
                            sortBy:(ProgramSortBy)sortBy
                             error:(NSError **)error;



// Function to obtain shows from a publisher
// if many functions for shows need to be added, the following function to be moved to ShowStore class
- (SearchResult *)showsFromPublisher:(NSString *)publisher
                           pageIndex:(NSUInteger)pageIndex
                            pageSize:(NSUInteger)pageSize
                              sortBy:(ProgramSortBy)sort
                               error:(NSError **)error;



// Caching
- (void)clearCache;

- (void)storeShowInCache:(Show *)show;

- (void)invalidateCacheForShow:(Show *)show;

@end
