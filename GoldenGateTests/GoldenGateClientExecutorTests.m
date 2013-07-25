#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "GoldenGateClientExecutor.h"
#import "ClientRequest.h"
#import "GoldenGateTests.h"

@interface GoldenGateClientExecutorTests : SenTestCase
@end

@implementation GoldenGateClientExecutorTests

- (void)test_execute_synchronized_returnsNonNull
{
    __SLOW_TEST__
    ClientExecutor *executor = [[ClientExecutor alloc] init];
    ClientRequest *request = [[ClientRequest alloc] init];
    request.url = [NSURL URLWithString:@"http://api.projecthelen.net/api/iptv/category/root"];

    ClientResponse *response = [executor execute:request];
    STAssertNotNil(response, nil);
}

@end