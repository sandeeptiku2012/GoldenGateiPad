#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestPlatform;
@class RestCategory;
@class RestCategoryList;
@class RestCategoryRating;
@class RestCategoryRating;

@interface CategoryClient : RestClient

- (id)initWithBaseURL:(NSString *)baseURL;

- (RestCategory *)rootCategoryForPlatform:(RestPlatform *)platform error:(NSError **)error;
- (RestCategory *)categoryWithId:(NSNumber *)categoryId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;
- (RestCategoryList *)subCategoriesForCategoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;
- (RestCategoryRating *)postRating:(RestCategoryRating *)rating categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform;
- (RestCategoryRating *)getRatingByUser:(NSNumber *)userId categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform error:(NSError **)error;
- (void)deleteRating:(NSNumber *)ratingId categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform error:(NSError **)error;

@end