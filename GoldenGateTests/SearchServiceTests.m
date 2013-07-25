#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "ClientExecutor.h"
#import "SearchClient.h"
#import "Constants.h"
#import "MockClientResponse.h"
#import "RestPlatform.h"
#import "ClientRequest.h"

@interface SearchServiceTests : SenTestCase
@end

@implementation SearchServiceTests {
}

- (void)test_assets_defaults_urlIsCorrect
{
    id mock = [OCMockObject partialMockForObject:[[ClientExecutor alloc] init]];
    SearchClient *service = [[SearchClient alloc] initWithBaseURI:kVimondBaseURL executor:mock];

    MockClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"assets":@{@"numberOfHits":[NSNumber numberWithLong:1004]}}];
    [[[mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request) {
        STAssertEqualObjects([request.url absoluteString], [kVimondBaseURL stringByAppendingString:@"/iptv/search/100"], nil);
        return YES;
    }]];

    [service getAssetsForPlatform:[RestPlatform platformWithName:@"iptv"] subCategory:@"100" query:nil sort:nil start:nil size:nil text:nil error:nil];

    [mock verify];
}

- (void)test_channels_defaults_urlIsCorrect
{
    id mock = [OCMockObject partialMockForObject:[[ClientExecutor alloc] init]];
    SearchClient *service = [[SearchClient alloc] initWithBaseURI:kVimondBaseURL executor:mock];

    MockClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"assets":@{@"numberOfHits":[NSNumber numberWithLong:1004]}}];
    [[[mock expect] andReturn:response] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request) {
        STAssertEqualObjects([request.url absoluteString], [kVimondBaseURL stringByAppendingString:@"/iptv/search/100"], nil);
        return YES;
    }]];

    [service getAssetsForPlatform:[RestPlatform platformWithName:@"iptv"] subCategory:@"100" query:nil sort:nil start:nil size:nil text:nil error:nil];

    [mock verify];
}

@end