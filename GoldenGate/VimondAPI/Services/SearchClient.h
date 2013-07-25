#import <Foundation/Foundation.h>
#import "RestClient.h"
#import "RestProgramSortBy.h"

@class RestSearchCategoryList;
@class RestSearchAssetList;
@class RestPlatform;

@interface SearchClient : RestClient

- (id)initWithBaseURI:(NSString *)string executor:(id)executor;

- (RestSearchAssetList *)getAssetsForPlatform:(RestPlatform *)platform
                                  subCategory:(NSString *)subCategory
                                        query:(NSString *)query
                                         sort:(RestProgramSortBy *)sortBy
                                        start:(NSNumber *)start
                                         size:(NSNumber *)size
                                         text:(NSString *)text
                                        error:(NSError **)error;

- (RestSearchCategoryList *)getCategoriesForPlatform:(RestPlatform *)platform
                                         subCategory:(NSString *)subCategory
                                               query:(NSString *)query
                                                sort:(RestProgramSortBy *)sortBy
                                               start:(NSNumber *)start
                                                size:(NSNumber *)size
                                                text:(NSString *)text
                                               error:(NSError **)error;

@end