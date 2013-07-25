//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "BlockDefinitions.h"
#import "DataFetching.h"

@interface PrefetchingDataSource : NSObject

+ (PrefetchingDataSource*)createWithDataFetcher:(id<DataFetching>)dataFetcher;

- (id)initWithDataFetcher:(id<DataFetching>)dataFetcher;

- (void)updateTotalObjectCount:(VoidHandler)onComplete errorHandler:(ErrorHandler)onError;


/*!
 @abstract 
 Get a data object at the given index. If the object is already fetched the successHandler is called immediately.
 Otherwise data will be fetched.
 */
- (void)fetchDataObjectAtIndex:(NSUInteger)index successHandler:(PagedObjectHandler)onSuccess errorHandler:(ErrorHandler)onError;

/*!
 @abstract
 Deletes any fetched data in this data source.
 */
- (void)resetDataSource;

/*!
 @abstract
 Direct access to any loaded data.
 @note
 Will NOT trigger fetching of data.
 Ideal for use after a call to preloadAllData
 */
- (NSObject*)objectAtIndex:(NSUInteger)index;

/*!
 @abstract
 The number of pages that should be prefetched on each side of the page currently fetched.
 The default is 1.
 */
@property (assign, nonatomic) NSUInteger pagesToPrefetchOnEachSide;

/*!
 @abstract
 The number of objects to request pr. page
 The default is 12
 */
@property (assign, nonatomic) NSUInteger objectsPrPage;


/*!
 @abstract
 returns the number of pages that this datasource has. 
 @note
 The last page is not necessarily full. This will return 0 before any data is loaded.
 */
@property (assign, nonatomic, readonly) NSUInteger pageCount;

/*!
 @abstract
 The last reported item count delivered when fetching the data.
 @note
 Will reset any loaded data when changed.
 */
@property (assign) NSUInteger cachedTotalItemCount;

/*!
 @abstract
 The datafetcher will do the actual fetching of the requested data.
 Please implement the DataFetching protocol!
 @note
 Changing dataFetcher will obviously clear any previously fetched data.
 */
@property (strong) id<DataFetching> dataFetcher;


/*!
 @abstract Set to yes if you want the data source to force a reload the next time
 an object is requested.
 
 */
@property (assign) BOOL dataDirty;


@property (assign, nonatomic) ProgramSortBy sortBy;

/*!
 @abstract
 Use this property to cap the data source at a certain amount of pages.
 0 means there is no page cap.
 */
@property (assign, nonatomic) NSInteger maxNumberOfPages;


@end