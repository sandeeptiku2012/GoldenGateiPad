//
//  BundleStore.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestProgramSortBy.h"

@class SearchResult;
@class Bundle;
@class SearchResult;

@interface BundleStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

- (Bundle *)bundleWithId:(NSUInteger)bundleId error:(NSError **)error;
- (SearchResult *)channelsForBundle:(Bundle *)bundle pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error;

// Caching
- (void)clearCache;

- (void)storeBundleInCache:(Bundle *)bundle;

- (void)invalidateCacheForBundle:(Bundle *)bundle;

@end
