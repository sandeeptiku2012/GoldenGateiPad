#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "RestClient.h"
#import "ClientExecutor.h"
#import "RestPlatform.h"
#import "ClientRequest.h"
#import "MockClientResponse.h"
#import "RestCategory.h"
#import "Constants.h"
#import "CategoryClient.h"
#import "RestCategoryRating.h"
#import "RestCategoryList.h"
#import "GoldenGateTests.h"

@interface CategoryClientTests : SenTestCase
@end

@implementation CategoryClientTests {
    CategoryClient *_client;
    id _mock;
}

- (void)setUp
{
    _mock = [OCMockObject partialMockForObject:[[ClientExecutor alloc] init]];
    _client = [[CategoryClient alloc] init];
    _client.baseURI = @"http://localhost/api";
    _client.executor = _mock;
}

- (void)test_rootCategoryForPlatform
{
    id response = [MockClientResponse responseWithJSONObject:@{@"category":@{@"@id":@"100"}}];
    [[[_mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^(ClientRequest *request)
    {
        STAssertEqualObjects([request.url absoluteString], [_client.baseURI stringByAppendingString:@"/iptv/category/root"], nil);
        return YES;
    }]];
    RestCategory *category = [_client rootCategoryForPlatform:[RestPlatform platformWithName:@"iptv"] error:nil];
    STAssertNotNil(category, nil);
    STAssertEqualObjects(category.identifier, [NSNumber numberWithLong:100], nil);

    [_mock verify];
}

- (void)test_postRating_default_shouldCallExecute
{
    id response = [MockClientResponse responseWithJSONObject:@{@"categoryRating":@{@"@id":@"441", @"userId":[NSNumber numberWithLong:1791838], @"rating":[NSNumber numberWithLong:5], @"crumb":@"", @"registered":@"2012-09-19T14:30:50.003Z"}}];
    [[[_mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request)
    {
        STAssertTrue([[request class] isSubclassOfClass:[ClientRequest class]], nil);
        STAssertNotNil(request.url, nil);
        STAssertEqualObjects(request.url.absoluteString, [_client.baseURI stringByAppendingString:@"/iptv/category/100/rating/"], nil);
        STAssertEqualObjects(request.method, @"POST", nil);
        return YES;
    }]];
    RestCategoryRating *rating = [[RestCategoryRating alloc] init];
    rating.rating = [NSNumber numberWithLong:5];
    rating.userId = [NSNumber numberWithLong:1791838];
    rating.categoryId = [NSNumber numberWithLong:100];

    [_client postRating:rating categoryId:[NSNumber numberWithLong:100] platform:[RestPlatform platformWithName:@"iptv"]];

    [_mock verify];
}

- (void)test_categoryWithId
{
    __SLOW_TEST__
    CategoryClient *client = [[CategoryClient alloc] initWithBaseURL:kVimondBaseURL];

    RestCategory *category = [client categoryWithId:@100 platform:[RestPlatform platformWithName:kVimondPlatform] expand:@"metadata" error:nil];

    STAssertNotNil(category, nil);
    STAssertEqualObjects(category.identifier, @100, nil);
}

- (void)test_subCategoriesForCategoryId
{
    __SLOW_TEST__
    CategoryClient *client = [[CategoryClient alloc] initWithBaseURL:kVimondBaseURL];

    RestCategoryList *categories = [client subCategoriesForCategoryId:@100 platform:[RestPlatform platformWithName:@"iptv"] expand:@"metadata" error:nil];

    DLog(@"categories; %@", categories);
    STAssertNotNil(categories, nil);
    STAssertTrue(categories.categories.count > 0, nil);
}

@end