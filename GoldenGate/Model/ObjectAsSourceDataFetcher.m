//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "ObjectAsSourceDataFetcher.h"


@implementation ObjectAsSourceDataFetcher
{
    BOOL _sourceObjectChanged;
}

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{
    NSAssert(NO, @"Must be re-implemented in subclasses");
}

- (BOOL)shouldResetData
{
    return _sourceObjectChanged;
}

- (void)didResetData
{
    _sourceObjectChanged = NO;
}

- (void)setSourceObject:(id)sourceObject
{
    _sourceObjectChanged = _sourceObject != sourceObject;
    _sourceObject = sourceObject;
}

@end