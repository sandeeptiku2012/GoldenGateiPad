//
//  DataFetcherProtocol.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/2/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlockDefinitions.h"
#import "RestProgramSortBy.h"

@protocol DataFetching <NSObject>

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError;

@optional
/*!
 @abstract
 Implement this method and have it return YES if you want data to be loaded because the datasource has changed.
 Not implementing this method will default in a NO.
 */
- (BOOL)shouldResetData;

/*!
 @abstract
 Called by PrefetchingDataSource when data is reset.
 Use to mark any reset any "dirty" flags that would cause shouldResetData to return YES.
 */
- (void)didResetData;


/*!
 @abstract
 If the class doesn't implement this method it defaults to YES.
 */
- (BOOL)doesSupportPaging;

@end
