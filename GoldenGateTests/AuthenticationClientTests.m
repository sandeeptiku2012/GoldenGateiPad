#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AuthenticationClient.h"
#import "ClientExecutorProtocol.h"
#import "ClientRequest.h"
#import "ClientExecutor.h"
#import "RestLoginResult.h"
#import "ClientResponse.h"
#import "MockClientResponse.h"
#import "Constants.h"
#import "GoldenGateTests.h"

@interface AuthenticationClientTests : SenTestCase
@end

@implementation AuthenticationClientTests {
    AuthenticationClient *_client;
    id _mock;
}

- (void)setUp
{
    _mock = [OCMockObject partialMockForObject:[ClientExecutor new]];
    _client = [[AuthenticationClient alloc] initWithBaseURL:@"http://localhost"];
    _client.executor = _mock;
}

- (void)test_login_shouldSendPost
{
    NSNumber *userId = [NSNumber numberWithLong:1791838];
    ClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"response":@{@"code":@"SESSION_AUTHENTICATED", @"description":@"Authenticated session", @"userId":userId}}];

    BOOL (^block)(ClientRequest *) = ^(ClientRequest *request)
    {
        STAssertEqualObjects(request.method, @"POST", nil);
        STAssertTrue([[request.url absoluteString] hasSuffix:@"/authentication/user/login"], nil);
        STAssertNotNil(request.body, nil);
        return YES;
    };
    [[[_mock expect] andReturn:response] execute:[OCMArg checkWithBlock:block]];

    RestLoginResult *result = [_client loginWithUsername:@"demo1" password:@"demo" rememberMe:YES];

    STAssertEqualObjects(result.userId, userId, nil);
    [_mock verify];
}

- (void)test_logout_shouldSendDelete
{
    ClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"response":@{@"code":@"SESSION_INVALIDATED", @"description":@"Session invalidated"}}];

    BOOL (^block)(ClientRequest *) = ^(ClientRequest *request)
    {
        STAssertEqualObjects(request.method, @"DELETE", nil);
        STAssertTrue([[request.url absoluteString] hasSuffix:@"/authentication/user/logout"], nil);
        return YES;
    };

    [[[_mock expect] andReturn:response] execute:[OCMArg checkWithBlock:block]];

    RestLoginResult *result = [_client logout];
    STAssertNotNil(result, nil);

    [_mock verify];
}

- (void)test_isSessionAuthenticated_shouldSendGet
{
    ClientResponse *response = [MockClientResponse responseWithJSONObject:@{@"response":@{@"code":@"SESSION_AUTHENTICATED", @"description":@"Authenticated session", @"userId":@1791838}}];

    BOOL (^block)(ClientRequest *) = ^(ClientRequest *request)
    {
        STAssertEqualObjects(request.method, @"GET", nil);
        STAssertTrue([[request.url absoluteString] hasSuffix:@"/authentication/user"], nil);
        return YES;
    };

    [[[_mock expect] andReturn:response] execute:[OCMArg checkWithBlock:block]];

    RestLoginResult *result = [_client isSessionAuthenticated];
    STAssertNotNil(result, nil);

    [_mock verify];
}

- (void)test_all
{
    __SLOW_TEST__

    AuthenticationClient *client = [[AuthenticationClient alloc] initWithBaseURL:kVimondBaseURL];
    BOOL wasLoggedIn = [[client isSessionAuthenticated].code isEqualToString:@"SESSION_AUTHENTICATED"];
    if (wasLoggedIn)
    {
        [client logout];
    }

    RestLoginResult *result = nil;
    result = [client loginWithUsername:@"laila+13@vimond.com" password:@"demo" rememberMe:YES];
    STAssertEqualObjects(result.code, @"AUTHENTICATION_OK", nil);

    result = [client isSessionAuthenticated];
    STAssertEqualObjects(result.code, @"SESSION_AUTHENTICATED", nil);

    result = [client logout];
    STAssertEqualObjects(result.code, @"SESSION_INVALIDATED", nil);

    result = [client isSessionAuthenticated];
    STAssertEqualObjects(result.code, @"SESSION_NOT_AUTHENTICATED", nil);

    if (wasLoggedIn)
    {
        result = [client loginWithUsername:@"laila+13@vimond.com" password:@"demo" rememberMe:YES];
        STAssertEqualObjects(result.code, @"AUTHENTICATION_OK", nil);
    }
}

// This is not really a test, but a convenience method to logout current user
- (void)_test_logout
{
    __SLOW_TEST__
    AuthenticationClient *client = [[AuthenticationClient alloc] initWithBaseURL:kVimondBaseURL];
    [client logout];
}

- (void)tearDown
{
    _client = nil;
    _mock = nil;
}

@end