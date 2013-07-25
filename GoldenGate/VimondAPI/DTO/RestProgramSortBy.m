#import "RestProgramSortBy.h"

@implementation RestProgramSortBy {
    ProgramSortBy _value;
}

+ (RestProgramSortBy*)createProgramWithEnum:(ProgramSortBy)value
{
    return [[RestProgramSortBy alloc]initWithEnum:value];
}

- (id)initWithEnum:(ProgramSortBy)value
{
    if (self = [super init])
    {
        _value = value;
    }
    return self;
}

- (NSString *)stringValue
{
    switch (_value)
    {
        case ProgramSortByDateAsc:
            return @"date asc";
        case ProgramSortByDateDesc:
            return @"date desc";
        case ProgramSortByName:
            return @"name";
        case ProgramSortByNameDesc:
            return @"name desc";
        case ProgramSortByPriority:
            return @"priority";
        case ProgramSortByCount:
            return @"count";
        case ProgramSortByRating:
            return @"rating";
        case ProgramSortByRatingCount:
            return @"ratingcount desc";
        case ProgramSortByViewAsc:
            return @"views";
        case ProgramSortByViewDesc:
            return @"views desc";
        case ProgramSortByNodeIdAsc:
            return @"category";
        case ProgramSortByNodeIdDesc:
            return @"nodeid desc";
        case ProgramSortByExpiryDateAsc:
            return @"expiry asc";
        case ProgramSortByExpiryDateDesc:
            return @"expiry desc";
        case ProgramSortByPublishedDateAsc:
            return @"published asc";
        case ProgramSortByPublishedDateDesc:
            return @"published desc";
        case ProgramSortByAssetTitleAsc:
            return @"asset title";
        case ProgramSortByAssetTitleDesc:
            return @"asset title desc";
        case ProgramSortByCategoryNameAsc:
            return @"category name asc";
        case ProgramSortByCategoryNameDesc:
            return @"category name desc";
        case ProgramSortByCategoryRatingCount:
            return @"category rating count";
        case ProgramSortByChannelPublishedDate:
            return @"channel published date";
        case ProgramSortByChannelSubscribers:
            return @"channel subscribers";
        case ProgramSortByDefault:
            break;
    }
    return @"";
}

@end