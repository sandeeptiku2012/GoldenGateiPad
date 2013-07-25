#import "ClientResponse.h"

@implementation ClientResponse

- (id)init
{
    if (self = [super init])
    {
        self.headers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    if (self = [self init])
    {
        self.data = data;
        self.headers = [[response allHeaderFields] mutableCopy];
        self.statusCode = response.statusCode;
        self.error = error;
    }
    return self;
}

- (NSString *)description
{
    NSString *bodyString = [self.data length] ? [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] : @"";
    return [NSString stringWithFormat:@"<%@: %p, status = %d, body = '%@'>", [self class], self, self.statusCode, bodyString];
}

- (BOOL)isSuccess
{
    return _statusCode >= 200 && _statusCode <= 299;
}

@end