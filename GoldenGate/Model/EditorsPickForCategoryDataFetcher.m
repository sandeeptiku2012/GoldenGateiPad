//
//  EditorsPickForCategoryDataFetcher.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "EditorsPickForCategoryDataFetcher.h"

#import "VimondStore.h"
#import "Channel.h"

@implementation EditorsPickForCategoryDataFetcher

- (void)fetchDataForPage:(NSUInteger)pageNumber
           objectsPrPage:(NSUInteger)objectsPrPage
                  sortBy:(ProgramSortBy)sortBy
          successHandler:(PagedObjectsHandler)onSuccess
            errorHandler:(ErrorHandler)onError
{

    NSError *error = nil;
    Channel *editorsPick = [[VimondStore channelStore] editorsPickForCategory:self.sourceObject error:&error];

    if (!error)
    {
        NSArray *editorsPickArray = editorsPick != nil ? @[editorsPick] : nil;
        onSuccess(editorsPickArray, editorsPickArray.count);
    }
    else
    {
        onError(error);
    }
}

- (BOOL)doesSupportPaging
{
    return NO;
}

@end
