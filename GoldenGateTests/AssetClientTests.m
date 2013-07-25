#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AssetClient.h"
#import "ClientExecutorProtocol.h"
#import "RestAssetRating.h"
#import "RestPlatform.h"
#import "ClientExecutor.h"
#import "ClientResponse.h"
#import "ClientRequest.h"
#import "Constants.h"
#import "MockClientResponse.h"
#import "RestAsset.h"

@interface AssetClientTests : SenTestCase
@end

@implementation AssetClientTests

NSString *userId = @"987654321";

- (void)test_getAsset
{
    NSNumber *assetId = @1234;

    AssetClient *client = [[AssetClient alloc] initWithBaseURL:kVimondBaseURL];
    id mock = [OCMockObject partialMockForObject:[[ClientExecutor alloc] init]];
    client.executor = mock;
    ClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"asset":@{@"@id":[assetId stringValue], @"@category":@100}}];
    [[[mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request)
    {
        NSString *url = [NSString stringWithFormat:@"%@/%@/asset/%@?expand=metadata", kVimondBaseURL, kVimondPlatform, assetId];
        STAssertEqualObjects([[request url] absoluteString], url, nil);
        return YES;
    }]];

    RestAsset *asset = [client getAsset:assetId platform:[RestPlatform platformWithName:kVimondPlatform] expand:@"metadata" error:nil];

    [mock verify];
    STAssertNotNil(asset, nil);
    STAssertEqualObjects(asset.identifier, assetId, nil);
}

- (void)test_postAssetRating
{
    AssetClient *service = [[AssetClient alloc] initWithBaseURL:kVimondBaseURL];
    id mock = [OCMockObject partialMockForObject:[[ClientExecutor alloc] init]];
    service.executor = mock;

    RestAssetRating *rating = [[RestAssetRating alloc] init];
    rating.userId = userId;
    rating.rating = @"RATING_5";
    rating.crumb = userId;

    RestPlatform *platform = [RestPlatform platformWithName:@"iptv"];

    ClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"rating":@{@"@id":@"23756", @"@uri":@"/api/iptv/asset/2177654/rating/23756"}}];
    NSNumber *assetId = @12345;
    [[[mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request)
    {
        NSString *expectedUri = [NSString stringWithFormat:@"%@/%@/asset/%@/rating", kVimondBaseURL, platform.name, assetId];
        STAssertEqualObjects([request.url absoluteString], expectedUri, nil);
        STAssertEqualObjects(request.method, @"POST", nil);
        STAssertTrue([[request.headers objectForKey:@"Accept"] hasPrefix:@"application/json"], nil);
        return YES;
    }]];

    RestAssetRating *result = [service postAssetRating:rating platform:platform assetId:assetId error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue([result isKindOfClass:[RestAssetRating class]], nil);

    [mock verify];
}

@end
