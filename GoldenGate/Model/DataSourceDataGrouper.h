//
//  Created by Andreas Petrov on 9/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PrefetchingDataSource;

@interface DataSourceDataGrouper : NSObject

- (id)initWithDataSource:(PrefetchingDataSource *)source groupingKeyFunction:(id <NSCopying> ( *)(id))groupingKeyFunction;

@property (strong, nonatomic) NSArray *groupedData;
@property (strong, nonatomic) NSArray *groupedDataKeys;

@end