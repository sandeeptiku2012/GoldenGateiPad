//
//  ShowSearchResultFetcher.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ShowSearchResultFetcher.h"
#import "SearchResult.h"
#import "VimondStore.h"

@implementation ShowSearchResultFetcher


- (SearchResult *)executeSearchWithSearchString:(NSString *)string
                                     pageNumber:(NSUInteger)pageNumber
                                  objectsPrPage:(NSUInteger)objectsPrPage
                                          error:(NSError**)error

{
    return [[VimondStore searchExecutor] findShowsWithSearchString:string pageNumber:pageNumber objectsPrPage:objectsPrPage error:error ];
            
}

@end
