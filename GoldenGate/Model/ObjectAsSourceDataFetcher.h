//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataFetching.h"


@interface ObjectAsSourceDataFetcher : NSObject <DataFetching>

@property (strong, nonatomic) id sourceObject;

@end