#import <SenTestingKit/SenTestingKit.h>
#import "ClientMethod.h"
#import "ClientRequest.h"
#import "ClientArguments.h"

static NSString *const google = @"http://google.com";

@interface ClientMethodTests : SenTestCase
@end

@implementation ClientMethodTests

- (void)test_methodWithBaseURI__shouldReturnNonNil
{
    ClientMethod *result = [[[ClientMethod alloc] init] BaseURI:google];

    ClientRequest *request = [result request];
    STAssertNotNil(request, nil);
    STAssertEqualObjects(request.url.absoluteString, google, nil);
}

- (void)test_methodWithArguments_noArguments_correctURL
{
    ClientMethod *method = [[[ClientMethod alloc] init] BaseURI:google];
    ClientArguments *arguments = [ClientArguments new];

    ClientRequest *request = [method requestWithArguments:arguments];

    STAssertEqualObjects(request.url.absoluteString, google, nil);
}

- (void)test_methodWithArguments_noArguments_GET
{
    ClientMethod *method = [[[ClientMethod alloc] init] BaseURI:google];
    ClientArguments *arguments = [ClientArguments new];

    ClientRequest *request = [method requestWithArguments:arguments];

    STAssertEqualObjects(request.method, @"GET", nil);
}

- (void)test_methodWithArguments_queryParameters
{
    ClientMethod *method = [[[[ClientMethod alloc] init] BaseURI:google] parameters:@[@"q"]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:@"test" forKey:@"q"];

    ClientRequest *request = [method requestWithArguments:arguments];

    STAssertEqualObjects(request.url.absoluteString, [google stringByAppendingString:@"?q=test"], nil);
}

- (void)test_methodWithArguments_formParameters
{
    ClientMethod *method = [[[[ClientMethod alloc] init] BaseURI:google] formParameters:@[@"q"]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:@"test" forKey:@"q"];

    ClientRequest *request = [method requestWithArguments:arguments];

    STAssertEqualObjects(request.bodyContentType, @"application/x-www-form-urlencoded", nil);
    NSString *body = [[NSString alloc] initWithData:request.body encoding:NSUTF8StringEncoding];
    STAssertEqualObjects(body, @"q=test", nil);
}

- (void)test_methodWithArguments_missingKeys
{
    ClientMethod *method = [[[[ClientMethod alloc] init] BaseURI:google] parameters:@[@"q"]];
    ClientArguments *arguments = [ClientArguments new];

    @try
    {
        [method requestWithArguments:arguments];
        STFail(@"Expected exception");
    } @catch (NSException *ex)
    {
        DLog(@"%@", ex);
    }
}

- (void)test_allKeys_queryParams_shouldReturnKeys
{
    ClientMethod *method = [[[[ClientMethod alloc] init] BaseURI:google] parameters:@[@"q"]];

    NSSet *keys = [method performSelector:@selector(allKeys)];

    STAssertEqualObjects(keys, [NSSet setWithArray:@[@"q"]], nil);
}

- (void)test_allKeys_pathParams_shouldReturnKeys
{
    ClientMethod *method = [[[[ClientMethod alloc] init] BaseURI:google] path:@"/{name}/item"];

    NSSet *keys = [method performSelector:@selector(allKeys)];

    STAssertEqualObjects(keys, [NSSet setWithArray:@[@"name"]], nil);
}

@end

