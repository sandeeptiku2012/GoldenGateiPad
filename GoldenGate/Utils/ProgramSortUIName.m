//
//  SortProgramUIName.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ProgramSortUIName.h"



@implementation ProgramSortUIName

+ (NSString*)uiNameForProgramSortBy:(ProgramSortBy)sortBy
{
    switch (sortBy)
    {
        case ProgramSortByName:
            return @"A-Z";
        case ProgramSortByViewDesc:
            return @"Views";
        case ProgramSortByRatingCount:
            return @"Likes";
        case ProgramSortByDateDesc:
        case ProgramSortByPublishedDateDesc:
            return @"New";
        default:
            break;
    }
    
    return @"";
}

@end
