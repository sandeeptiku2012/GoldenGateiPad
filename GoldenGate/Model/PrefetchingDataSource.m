//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "PrefetchingDataSource.h"

@interface PrefetchingDataSource ()
{
    NSUInteger _cachedTotalItemCount;
    id <DataFetching> _dataFetcher;
}

@property (strong) NSMutableDictionary *dataPageDict;

@property (assign, nonatomic) BOOL dataFetcherSupportsPaging;

@property (strong) NSMutableDictionary *dataFetchingOperationForPageDict;

@property (strong) NSOperationQueue *operationQueue;

@property (strong) NSOperation *totalCountUpdatedOperation;

@end

@implementation PrefetchingDataSource


+ (PrefetchingDataSource *)createWithDataFetcher:(id <DataFetching>)dataFetcher
{
    return [[PrefetchingDataSource alloc] initWithDataFetcher:dataFetcher];
}

- (id)initWithDataFetcher:(id <DataFetching>)dataFetcher
{
    if ((self = [self init]))
    {
        self.dataFetcher = dataFetcher;
        self.operationQueue = [NSOperationQueue new];
    }

    return self;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self resetDataSource];
        self.pagesToPrefetchOnEachSide = 1;
        self.objectsPrPage = 12;
        self.dataDirty = YES;
    }

    return self;
}

- (void)setDataFetcherClean
{
    if ([self.dataFetcher respondsToSelector:@selector(didResetData)])
    {
        [self.dataFetcher didResetData];
    }
}

- (void)updateTotalObjectCount:(VoidHandler)onComplete errorHandler:(ErrorHandler)onError
{
    NSAssert(self.dataFetcher != nil, @"Must have a datafetcher before calling this method");

    if (![self shouldReloadData]) // Don't update object count if data it isn't needed
    {
        onComplete();
        return;
    }

    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    [self.operationQueue addOperationWithBlock:^
    {
        [self.dataFetcher fetchDataForPage:0
                             objectsPrPage:0
                                    sortBy:ProgramSortByDefault
                            successHandler:^(NSArray *objectsOnPage, NSUInteger totalObjectCount)
                            {
                                [self setDataFetcherClean];
                                self.cachedTotalItemCount = totalObjectCount;
                                [currentQueue addOperationWithBlock:^
                                {
                                    if (onComplete)
                                    {
                                        onComplete();
                                    }
                                }];
                            }
                              errorHandler:^(NSError *error)
                              {
                                  [currentQueue addOperationWithBlock:^
                                  {
                                      if (onError)
                                      {
                                          onError(error);
                                      }
                                  }];
                              }];
    }];
}

- (void)dataObjectAtIndex:(NSUInteger)index
           successHandler:(PagedObjectHandler)onSuccess
             errorHandler:(ErrorHandler)onError
{
    NSObject *objectAtIndex = [self objectAtIndex:index];

    if (objectAtIndex && onSuccess)
    {
        onSuccess(objectAtIndex);
    }
    else
    {
        NSInteger pageForIndex = [self calculatePageForIndex:index];
        NSInteger firstPageToLoad = MAX((NSInteger) pageForIndex - (NSInteger) self.pagesToPrefetchOnEachSide, 0); // first page can not be negative
        NSInteger lastPageToLoad = pageForIndex + self.pagesToPrefetchOnEachSide;
        NSInteger pagesToLoad = MAX(lastPageToLoad - firstPageToLoad, 1); // Must load at least one page
        NSInteger minimumPages = (self.pagesToPrefetchOnEachSide * 2) + 1;

        // If loading is capped in the negative direction let's make sure we still load
        // the wanted number of pages.
        if (pagesToLoad < minimumPages)
        {
            NSUInteger extraPages = minimumPages - pagesToLoad;
            lastPageToLoad += extraPages;
        }

        // Cap last page to load at maximum page count.
        NSInteger requiredPageCount = [self requiredPagesForObjectCount:self.cachedTotalItemCount];
        lastPageToLoad = MIN(lastPageToLoad, requiredPageCount - 1);

        if (lastPageToLoad == -1)
        {
            onSuccess(nil);
        }

        for (NSInteger pageIndex = firstPageToLoad; pageIndex <= lastPageToLoad; ++pageIndex)
        {
            NSArray *itemsAtPage = [self itemsForPage:pageIndex];
            BOOL needsToFetchPage = itemsAtPage == nil;
            if (needsToFetchPage)
            {
                [self fetchAndStorePage:pageIndex objectIndex:index successHandler:onSuccess errorHandler:onError];
            }
            else
            {
                NSObject *objectOnPage = [self objectAtIndex:index];
                if (onSuccess)
                {
                    onSuccess(objectOnPage);
                }
            }
        }
    }
}

- (void)fetchDataObjectAtIndex:(NSUInteger)index
                successHandler:(PagedObjectHandler)onSuccess
                  errorHandler:(ErrorHandler)onError
{
    if ([self shouldReloadData])
    {
        [self resetDataSource];
    }

    // Before we can do anything, we need to update the total count
    if (self.totalCountUpdatedOperation == nil)
    {
        self.totalCountUpdatedOperation = [NSBlockOperation blockOperationWithBlock:^
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                [self dataObjectAtIndex:index successHandler:onSuccess errorHandler:onError];
            }];
        }];

        [self.operationQueue addOperationWithBlock:^
        {
            [self.dataFetcher fetchDataForPage:0
                                 objectsPrPage:0
                                        sortBy:ProgramSortByDefault
                                successHandler:^(NSArray *objectsOnPage, NSUInteger totalObjectCount)
                                {
                                    self.cachedTotalItemCount = totalObjectCount;

                                    // In times with heavy resetting of data this code might be ran even after the operation is finished.
                                    if (!self.totalCountUpdatedOperation.isFinished)
                                    {
                                        [self.operationQueue addOperation:self.totalCountUpdatedOperation];
                                    }
                                }
                                  errorHandler:^(NSError *error)
                                  {
                                      if (onError)
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                          {
                                              //Satish: set to nil on error. Other wise the variable is initialized but not added
                                              //to operation queue
                                              self.totalCountUpdatedOperation = nil;
                                             
                                              onError(error);
                                          }];
                                      }
                                  }];
        }];
    }
    else
    {
        // Any future calls after object count has been updated will be
        // dependent on the operation that updated the object count.
        NSOperation *fetchDataObjectOperation = [NSBlockOperation blockOperationWithBlock:^
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                [self dataObjectAtIndex:index successHandler:onSuccess errorHandler:onError];
            }];
        }];

        
            [fetchDataObjectOperation addDependency:self.totalCountUpdatedOperation];
        
        
        [self.operationQueue addOperation:fetchDataObjectOperation];
    }
}

- (void)fetchAndStorePage:(NSUInteger)pageIndex
              objectIndex:(NSUInteger)objectIndex
           successHandler:(PagedObjectHandler)successHandler
             errorHandler:(ErrorHandler)onError
{
    NSAssert(self.dataFetcher != nil, @"Must have a datafetcher before calling this method");
    
    NSUInteger pageForObjectIndex = [self calculatePageForIndex:objectIndex];
    NSOperation *fetchPageDataOperation = [self fetchOperationForPageIndex:pageIndex];
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if (fetchPageDataOperation == nil)
    {
        fetchPageDataOperation = [NSBlockOperation blockOperationWithBlock:^
        {
            [self.dataFetcher fetchDataForPage:pageIndex
                                 objectsPrPage:self.objectsPrPage
                                        sortBy:self.sortBy
                                successHandler:^(NSArray *objectsOnPage, NSUInteger totalObjectCount)
                                {
                                    [self setDataFetcherClean];
                                    [self storePagedData:objectsOnPage forPageIndex:pageIndex totalObjectCount:totalObjectCount];
                                    [self clearFetchOperationForPageIndex:pageIndex];
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                    {
                                        if (pageIndex == pageForObjectIndex)
                                        {
                                            successHandler([self objectAtIndex:objectIndex]);
                                        }
                                    }];
                                }
                                  errorHandler:^(NSError *error)
                                  {
                                      [currentQueue addOperationWithBlock:^
                                      {
                                          onError(error);
                                      }];
                                  }];;
        }];

        [self.dataFetchingOperationForPageDict setObject:fetchPageDataOperation forKey:@(pageIndex)];
        [self.operationQueue addOperation:fetchPageDataOperation];
    }
    else if (pageIndex == pageForObjectIndex)
    {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                successHandler([self objectAtIndex:objectIndex]);
            }];
        }];

        [operation addDependency:fetchPageDataOperation];
        [self.operationQueue addOperation:operation];
    }
}

- (void)clearFetchOperationForPageIndex:(NSUInteger)pageIndex
{
    [self.dataFetchingOperationForPageDict removeObjectForKey:@(pageIndex)];
}

- (NSOperation *)fetchOperationForPageIndex:(NSUInteger)pageIndex
{
    return [self.dataFetchingOperationForPageDict objectForKey:@(pageIndex)];
}

- (NSUInteger)requiredPagesForObjectCount:(NSUInteger)objectCount
{
    return self.dataFetcherSupportsPaging ? (NSUInteger) ceil((double) objectCount / self.objectsPrPage) : 1;
}

- (void)storePagedData:(NSArray *)objectsOnPage forPageIndex:(NSUInteger)pageIndex totalObjectCount:(NSUInteger)totalObjectCount
{
    self.cachedTotalItemCount = totalObjectCount;
    if (objectsOnPage && totalObjectCount != 0)
    {
        [self.dataPageDict setObject:objectsOnPage forKey:@(pageIndex)];
    }
}

- (NSObject *)objectAtIndex:(NSUInteger)index
{
    NSObject *object = nil;
    if ([self shouldReloadData])
    {
        [self resetDataSource];
    }
    else
    {
        NSArray *objectsAtPage = [self itemsForPage:[self calculatePageForIndex:index]];
        if (objectsAtPage)
        {
            NSUInteger indexInPage = [self calculatePagedIndexFromIndex:index];
            if (indexInPage < objectsAtPage.count)
            {
                object = [objectsAtPage objectAtIndex:indexInPage];
            }
            else
            {
                // If we ever get here something bad has happened and we need to reset the data.
                [self resetDataSource];
            }
        }
    }

    return object;
}

- (void)resetDataSource
{
    [self.operationQueue cancelAllOperations];
    self.totalCountUpdatedOperation = nil;
    self.dataPageDict = [NSMutableDictionary new];
    self.dataFetchingOperationForPageDict = [NSMutableDictionary new];
    self.cachedTotalItemCount = 0;
    self.dataDirty = NO;

    self.dataFetcherSupportsPaging = YES;
    if ([self.dataFetcher respondsToSelector:@selector(doesSupportPaging)])
    {
        self.dataFetcherSupportsPaging = [self.dataFetcher doesSupportPaging];
    }

    // Notify fetcher that data was reset.
    if ([self.dataFetcher respondsToSelector:@selector(didResetData)])
    {
        [self.dataFetcher didResetData];
    }
}

- (NSArray *)itemsForPage:(NSUInteger)pageIndex
{
    NSArray *itemsForPage = nil;
    NSObject *obj = [self.dataPageDict objectForKey:@(pageIndex)];

    // self.dataPageArray can contain NSNull objects. Check that we're actually returning an NSArray
    if ([obj isKindOfClass:[NSArray class]])
    {
        itemsForPage = (NSArray *) obj;
    }

    return itemsForPage;
}

- (NSUInteger)calculatePagedIndexFromIndex:(NSUInteger)index
{
    return self.dataFetcherSupportsPaging ? index % self.objectsPrPage : index;
}

- (NSUInteger)calculatePageForIndex:(NSUInteger)index
{
    return self.dataFetcherSupportsPaging ? index / self.objectsPrPage : 0;
}

- (BOOL)doesDataFetcherWantReload
{
    BOOL fetcherWantsReload = NO;

    if ([self.dataFetcher respondsToSelector:@selector(shouldResetData)])
    {
        fetcherWantsReload = self.dataFetcher.shouldResetData;
    }

    return fetcherWantsReload;
}

- (BOOL)shouldReloadData
{
    return self.dataDirty || self.dataPageDict == nil || self.doesDataFetcherWantReload;
}

#pragma mark - Properties

- (NSUInteger)pageCount
{
    return [self requiredPagesForObjectCount:self.cachedTotalItemCount];
}

- (void)setCachedTotalItemCount:(NSUInteger)cachedTotalItemCount
{
    @synchronized (self)
    {
        BOOL changed = cachedTotalItemCount != _cachedTotalItemCount;
        self.dataDirty &= changed;

        // Cap item-count if so specified
        if (self.maxNumberOfPages > 0)
        {
            NSUInteger maximumAllowedItems = self.objectsPrPage * self.maxNumberOfPages;
            cachedTotalItemCount = MIN(maximumAllowedItems, cachedTotalItemCount);
        }

        _cachedTotalItemCount = cachedTotalItemCount;
    }
}

- (NSUInteger)cachedTotalItemCount
{
    @synchronized (self)
    {
        return _cachedTotalItemCount;
    }
}

- (void)setObjectsPrPage:(NSUInteger)objectsPrPage
{
    BOOL changed = objectsPrPage != _objectsPrPage;
    self.dataDirty &= changed;

    _objectsPrPage = objectsPrPage;
}

- (void)setDataFetcher:(id <DataFetching>)dataFetcher
{
    @synchronized (self)
    {
        self.dataDirty = YES;
        _cachedTotalItemCount = 0;
        _dataFetcher = dataFetcher;
    }
}

- (id <DataFetching>)dataFetcher
{
    @synchronized (self)
    {
        return _dataFetcher;
    }
}

- (void)setSortBy:(ProgramSortBy)sortBy
{
    BOOL changed = sortBy != _sortBy;
    _dataDirty |= changed;
    _sortBy = sortBy;
}

@end