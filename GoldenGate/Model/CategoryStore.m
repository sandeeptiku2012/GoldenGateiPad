#import "CategoryStore.h"
#import "CategoryClient.h"
#import "Constants.h"
#import "RestPlatform.h"
#import "ContentCategory.h"
#import "RestCategory.h"
#import "RestCategoryList.h"
#import "TreeNodeCache.h"

@interface CategoryStore()

@property (strong) TreeNodeCache *categoryCache;

@end

@implementation CategoryStore {
    CategoryClient *_categoryClient;
    RestPlatform *_platform;
    RestCategory *_rootCategory;
}

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform = [RestPlatform platformWithName:platformName];
        _categoryClient  = [[CategoryClient alloc] initWithBaseURL:baseURL];
        _categoryCache   = [TreeNodeCache new];
    }
    return self;
}

- (id)init
{
    return [self initWithBaseURL:kVimondBaseURL platformName:nil];
}

- (void)clearCache
{
    [_categoryCache clearCache];
}

- (NSNumber *)rootCategoryID:(NSError **)error
{
    return @([self rootCategory:error].identifier);
}

- (ContentCategory *)rootCategory:(NSError **)error
{
    if (_rootCategory == nil)
    {
        NSError *err = nil;
        _rootCategory = [_categoryClient rootCategoryForPlatform:_platform error:&err];
        if (err != nil)
        {
            if (error != nil)
            {
                *error = err;
            }
            DLog(@"error: %@", err);
            return nil;
        }
    }
    ContentCategory *categoryObject = [_rootCategory categoryObject];
    
    [self storeCategory:categoryObject];
    
    return categoryObject;
}

- (NSArray *)subCategoriesForCategory:(ContentCategory *)category error:(NSError **)error
{
    NSNumber *categoryID = [NSNumber numberWithLongLong:category.identifier];

    // Look for cached subcategories
    NSArray *subCategories = [self.categoryCache childNodesForNodeWithKey:categoryID];

    if (subCategories == nil)
    {
        RestCategoryList *categoryList = [_categoryClient subCategoriesForCategoryId:categoryID
                                                                            platform:_platform
                                                                              expand:@"metadata"
                                                                               error:error];
        
        NSMutableArray *result = [NSMutableArray new];
        for (RestCategory *restCategory in categoryList.categories)
        {
            ContentCategory *categoryObject = [restCategory categoryObject];
            [self storeCategory:categoryObject];
            [result addObject:categoryObject];
        }
        
        subCategories = result;
        [self.categoryCache storeChildNodes:subCategories forNodeWithKey:categoryID];
    }
    
    return subCategories;
}

- (ContentCategory *)categoryWithId:(NSUInteger)categoryId error:(NSError **)error
{
    NSNumber *identifier = [NSNumber numberWithUnsignedInteger:categoryId];
    ContentCategory *categoryObject = [self.categoryCache nodeWithKey:identifier];

    BOOL categoryNotInCache = categoryObject == nil;
    if (categoryNotInCache)
    {
        RestCategory *category = [_categoryClient categoryWithId:identifier
                                                        platform:_platform
                                                          expand:@"metadata"
                                                           error:error];
        categoryObject = [category categoryObject];
        [self storeCategory:categoryObject];
    }

    return categoryObject;
}

- (void)storeCategory:(ContentCategory *)category
{
    [self.categoryCache storeNode:category withKey:@(category.identifier)];
}

@end