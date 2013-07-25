#import <Foundation/Foundation.h>

@class ContentCategory;

@interface CategoryStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

- (NSNumber*)rootCategoryID:(NSError **)error;
- (ContentCategory *)rootCategory:(NSError **)error;
- (NSArray *)subCategoriesForCategory:(ContentCategory *)category error:(NSError **)error;
- (ContentCategory *)categoryWithId:(NSUInteger)categoryId error:(NSError **)error;

- (void)clearCache;

@end