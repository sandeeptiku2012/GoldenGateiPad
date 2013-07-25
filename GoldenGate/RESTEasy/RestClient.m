#import "RestClient.h"
#import "GoldenGateClientExecutor.h"
#import "Constants.h"
#import "ClientResponse.h"
#import "ClientRequest.h"
#import "ClientMethod.h"
#import "ClientArguments.h"

#define kAuthenticationFailedStatusCode 401
NSString *kAuthenticationFailedNotification = @"AuthenticationFailedNotification";

@implementation RestClient

- (id)init
{
    if (self = [super init])
    {
        self.executor = [[ClientExecutor alloc] init];
    }
    
    return self;
}

- (id)initWithBaseURL:(NSString *)baseURL
{
    if (self = [self init])
    {
        self.baseURI = baseURL;
    }
    return self;
}

- (ClientResponse *)execute:(ClientRequest *)request
{
    DLog(@"%@ '%@'", request.method, request.url);
    return [self.executor execute:request];
}

- (ClientMethod *)createMethod
{
    return [[[ClientMethod alloc] init] BaseURI:self.baseURI];
}

- (id)execute:(ClientMethod *)method arguments:(ClientArguments *)arguments error:(NSError **)error
{
    NSError *err;
    ClientRequest *request = [method requestWithArguments:arguments];
    ClientResponse *response = [self execute:request];
    
    
    if (![response isSuccess])
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:kVimondErrorDomain
                                         code:response.statusCode
                                     userInfo:@{@"response":response, @"error":response.error != nil ? response.error : [NSNull null]}];
        }
        
        return nil;
    }

    if (method.returnType == nil)
    {
        return nil;
    }

    id returnValue = nil;
    
    @try {
        returnValue = [self.executor readType:method.returnType fromResponse:response error:&err];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    

    if (err != nil)
    {
        if (error != nil)
        {
            *error = err;
        }
        return nil;
    }
    return returnValue;
}

@end