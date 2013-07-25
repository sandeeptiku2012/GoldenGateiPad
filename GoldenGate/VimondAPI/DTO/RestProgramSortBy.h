#import <Foundation/Foundation.h>

typedef enum {
    ProgramSortByDefault,
    ProgramSortByDateAsc,
    ProgramSortByDateDesc,
    ProgramSortByName,
    ProgramSortByNameDesc,
    ProgramSortByPriority,
    ProgramSortByCount,
    ProgramSortByRating,
    ProgramSortByRatingCount,
    ProgramSortByViewAsc,
    ProgramSortByViewDesc,
    ProgramSortByNodeIdAsc,
    ProgramSortByNodeIdDesc,
    ProgramSortByExpiryDateAsc,
    ProgramSortByExpiryDateDesc,
    ProgramSortByPublishedDateAsc,
    ProgramSortByPublishedDateDesc,
    ProgramSortByAssetTitleAsc,
    ProgramSortByAssetTitleDesc,
    ProgramSortByCategoryNameAsc,
    ProgramSortByCategoryNameDesc,
    ProgramSortByCategoryRatingCount,
    ProgramSortByChannelPublishedDate,
    ProgramSortByChannelSubscribers
} ProgramSortBy;

@interface RestProgramSortBy : NSObject

- (id)initWithEnum:(ProgramSortBy)value;
+ (RestProgramSortBy*)createProgramWithEnum:(ProgramSortBy)value;

@end