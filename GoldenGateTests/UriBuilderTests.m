#import <SenTestingKit/SenTestingKit.h>
#import "UriBuilder.h"
#import "RestPlatform.h"

@interface UriBuilderTests : SenTestCase
@end

@implementation UriBuilderTests

- (void)test_pathParameters
{
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:@"http://api.projecthelen.net/api/{platform}/asset/{assetId}/rating"];
    [builder setObject:@"iptv" forPathParameter:@"platform"];
    [builder setObject:@"1234" forPathParameter:@"assetId"];

    NSString *urlString = [builder stringValue];

    STAssertEqualObjects( urlString, @"http://api.projecthelen.net/api/iptv/asset/1234/rating", nil );
}

- (void)test_queryParameters
{
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:@"http://api.projecthelen.net/api/authentication/user/login"];
    [builder setObject:@"user" forQueryParameter:@"username"];
    [builder setObject:@"pass" forQueryParameter:@"password"];

    NSString *urlString = [builder stringValue];

    STAssertEqualObjects( urlString, @"http://api.projecthelen.net/api/authentication/user/login?username=user&password=pass", nil );
}

- (void)test_pathParameters_object_shouldUseStringValue
{
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:@"http://api.projecthelen.net/api/{platform}/category/root"];
    [builder setObject:[RestPlatform platformWithName:@"iptv"] forPathParameter:@"platform"];

    NSString *urlString = [builder stringValue];

    STAssertEqualObjects( urlString, @"http://api.projecthelen.net/api/iptv/category/root", nil );
}

- (void)test_stringValue_queryParameters_returnsEscapedParameters
{
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:@"http://localhost/api"];
    [builder setObject:@"user name" forQueryParameter:@"username"];

    NSString *uri = [builder stringValue];

    STAssertEqualObjects(uri, @"http://localhost/api?username=user%20name", nil);
}

@end