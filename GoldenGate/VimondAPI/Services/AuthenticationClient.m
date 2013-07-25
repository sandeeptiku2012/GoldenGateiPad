#import "AuthenticationClient.h"
#import "RestLoginResult.h"
#import "ClientRequest.h"
#import "ClientExecutor.h"
#import "ClientResponse.h"
#import "ClientMethod.h"
#import "ClientArguments.h"
#import "WebUtil.h"

@implementation AuthenticationClient

- (id)initWithBaseURL:(NSString *)baseURL
{
    if (self = [super init])
    {
        self.baseURI = baseURL;
    }
    return self;
}

- (RestLoginResult *)isSessionAuthenticated
{
    ClientMethod *method = [[[[self createMethod] GET] path:@"/authentication/user"] returns:[RestLoginResult class]];

    ClientArguments *arguments = [ClientArguments new];

    return [self execute:method arguments:arguments error:nil];
}

- (RestLoginResult *)loginWithUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe
{
    NSString *pathTemplate = @"/authentication/user/login";

    ClientMethod *method = [[[[self createMethod] POST] path:pathTemplate] returns:[RestLoginResult class]];
    ClientRequest *request = [[ClientRequest alloc] init];
    request.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURI, pathTemplate]];
    request.method = @"POST";
    request.body = [[@{@"username":username, @"password":password, @"rememberMe":rememberMe ? @"true" : @"false"} queryString] dataUsingEncoding:NSUTF8StringEncoding];

    ClientResponse *response = [self.executor execute:request];

    return [self.executor readType:method.returnType fromResponse:response error:nil];
}

- (RestLoginResult *)logout
{
    ClientMethod *method = [[[[self createMethod] DELETE] path:@"/authentication/user/logout"] returns:[RestLoginResult class]];

    return [self execute:method arguments:nil error:nil];
}

@end