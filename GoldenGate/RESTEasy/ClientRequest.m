#import "ClientRequest.h"

@implementation ClientRequest

- (id)init
{
    if (self = [super init])
    {
        self.method = @"GET";
        self.headers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)POST
{
    self.method = @"POST";
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, url = '%@', method = '%@', body = %@>", [self class], self, self.url, self.method, self.body ? [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding] : @"nil"];
}

- (NSURL *)url
{
    return _url != nil ? _url : [NSURL URLWithString:_urlString];
}

- (NSString *)urlString
{
    return _urlString != nil ? _urlString : ([_url absoluteString]);
}

@end