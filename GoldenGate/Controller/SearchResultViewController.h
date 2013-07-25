//
//  SearchResultViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "DoublePagedGridViewController.h"

@interface SearchResultViewController : DoublePagedGridViewController

- (void)executeSearchWithSearchString:(NSString*)searchString;

@end
