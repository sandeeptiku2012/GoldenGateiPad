//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "CategoryActionFactory.h"
#import "NavAction.h"
#import "CategoryAction.h"
#import "ContentCategory.h"
#import "VimondStore.h"
#import "MyChannelsAction.h"
#import "FavoritesAction.h"

@interface CategoryActionFactory()

@property (strong, nonatomic) NSMutableDictionary *categoryActionDict;

@end

@implementation CategoryActionFactory
{

}

+ (CategoryActionFactory *)sharedInstance
{
    static CategoryActionFactory *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _categoryActionDict = [NSMutableDictionary new];
    }

    return self;
}

- (void)storeCategoryAction:(CategoryAction *)action
{
    NSNumber *identifier = @(action.category.identifier);
    if (action && [self.categoryActionDict objectForKey:identifier] == nil)
    {
        [self.categoryActionDict setObject:action forKey:identifier];
    }
}

- (CategoryAction *)createCategoryActionForCategoryID:(NSNumber *)identifier
{
    NSError *error;
    ContentCategory *categoryWithIdentifier = [[VimondStore categoryStore] categoryWithId:[identifier unsignedIntegerValue] error:&error];
    CategoryAction *categoryAction = nil;

    if (!error)
    {
        categoryAction = [[CategoryAction alloc] initWithCategory:categoryWithIdentifier];
        [self storeCategoryAction:categoryAction];

        if (categoryWithIdentifier.categoryLevel != ContentCategoryLevelTop)
        {
            // Recursively populate the category tree until
            CategoryAction * parentAction = [self createCategoryActionForCategoryID:@(categoryWithIdentifier.parentId)];
            categoryAction.parentAction = parentAction;
        }
    }

    return categoryAction;
}

- (CategoryAction*)categoryActionForCategoryID:(NSNumber *)identifier
{
    KITAssertIsNotOnMainQueue();
    
    NSAssert(identifier, @"Don't be sending empty identifiers here man!");

    CategoryAction *categoryAction = [self.categoryActionDict objectForKey:identifier];
    if (categoryAction == nil)
    {
        categoryAction = [self createCategoryActionForCategoryID:identifier];
    }

    return categoryAction;
}

- (CategoryAction *)categoryActionForCategory:(ContentCategory*)category
{
    CategoryAction *categoryAction = [self.categoryActionDict objectForKey:@(category.identifier)];
    if (categoryAction == nil)
    {
        categoryAction = [[CategoryAction alloc]initWithCategory:category];
        [self storeCategoryAction:categoryAction];
    }
    
    return categoryAction;
}

- (NSArray *)subcategoryActionsForCategory:(ContentCategory *)category
{
    NSMutableArray *subcategoryActions = [NSMutableArray new];
    BOOL isDeepestAllowedCategoryLevel = category.categoryLevel >= ContentCategoryLevelSub;
    if (isDeepestAllowedCategoryLevel)
    {
        return subcategoryActions;
    }

    if (category.categoryLevel <= ContentCategoryLevelMain)
    {
        //[subcategoryActions addObject:[MyChannelsAction new]]; 
       // [subcategoryActions addObject:[FavoritesAction new]]; Satish: commented Favorite Videos section from category navigation
    }

    KITAssertIsNotOnMainQueue();
    
    NSError *error;
    NSArray *subCategories = [[VimondStore categoryStore] subCategoriesForCategory:category error:&error];
    for (ContentCategory *subCategory in subCategories)
    {
        CategoryAction *subCategoryAction = [[CategoryAction alloc] initWithCategory:subCategory];
        [self storeCategoryAction:subCategoryAction];
        [subcategoryActions addObject:subCategoryAction];
    }

    return subcategoryActions;
}

@end