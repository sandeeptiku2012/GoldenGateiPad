#import "MockClientResponse.h"

@implementation MockClientResponse {
}

+ (id)responseWithJSONObject:(id)object
{
    MockClientResponse *response = [[MockClientResponse alloc] init];
    response.data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    [response.headers setObject:@"application/json;charset=utf-8" forKey:@"Content-Type"];
    response.statusCode = 200;
    return response;
}

@end