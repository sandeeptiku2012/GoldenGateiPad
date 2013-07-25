#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestSearchCategoryList;
@class RestPlatform;
@class RestProgramSortBy;
@class RestSearchAssetList;

@interface UserContentClient : RestClient


- (RestSearchCategoryList *)getAccessibleCategoriesForUser:(NSNumber *)userId platform:(RestPlatform *)platform sort:(RestProgramSortBy *)sort start:(NSNumber *)start size:(NSNumber *)size query:(NSString*)query error:(NSError **)error;
- (RestSearchAssetList *)getAccessibleAssetsForUser:(NSNumber *)userId platform:(RestPlatform *)platform sort:(RestProgramSortBy *)sort start:(NSNumber *)start size:(NSNumber *)size error:(NSError **)error;

@end