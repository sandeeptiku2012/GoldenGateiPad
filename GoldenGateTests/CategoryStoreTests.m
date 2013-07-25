#import <SenTestingKit/SenTestingKit.h>
#import "CategoryStore.h"
#import "Constants.h"
#import "ContentCategory.h"
#import "GoldenGateTests.h"

@interface CategoryStoreTests : SenTestCase
@end

@implementation CategoryStoreTests {
}

- (void)test_rootCategory
{
    __SLOW_TEST__
    CategoryStore *store = [[CategoryStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform];

    NSError *error = nil;
    ContentCategory *category = [store rootCategory:&error];

    STAssertNotNil(category, nil);
    STAssertTrue(category.identifier == 100, nil);
}

- (void)test_subCategories
{
    __SLOW_TEST__
    CategoryStore *store = [[CategoryStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform];

    NSArray *categories = [store subCategoriesForCategory:[store rootCategory:nil] error:nil];

    STAssertNotNil(categories, nil);
    for (ContentCategory *category in categories)
    {
        DLog(@"Category #%d, title = '%@'", category.identifier, category.title);
    }
}

- (void)test_category
{
    __SLOW_TEST__
    CategoryStore *store = [[CategoryStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform];

    ContentCategory *rootCategory = [store rootCategory:nil];
    ContentCategory *category = [store categoryWithId:rootCategory.identifier error:nil];

    STAssertNotNil(category, nil);
    STAssertEqualObjects(category.title, @"Featured", nil);
    DLog(@"category: %@", category);
}

@end
