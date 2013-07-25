#import "ClientMethod.h"
#import "ClientRequest.h"
#import "UriBuilder.h"
#import "RestCategoryRating.h"
#import "ClientArguments.h"
#import "WebUtil.h"

@interface ClientMethod () {
    NSMutableString *_pathTemplate;
    NSMutableDictionary *_pathParams;
    NSMutableDictionary *_queryParams;
    NSMutableSet *_queryParameterNames;
    NSMutableSet *_formParameters;
    id _body;
}

@end

@implementation ClientMethod

- (id)init
{
    if (self = [super init])
    {
        _pathTemplate = [NSMutableString string];
        _pathParams = [NSMutableDictionary dictionary];
        _queryParams = [NSMutableDictionary dictionary];
        _queryParameterNames = [NSMutableSet set];
        _formParameters = [NSMutableSet set];
        _returnType = nil;
    }
    return self;
}

- (ClientMethod *)returns:(Class)clazz
{
    self.returnType = clazz;
    return self;
}

- (ClientMethod *)BaseURI:(NSString *)string
{
    self.baseURI = string;
    return self;
}

#pragma mark - Path

- (ClientMethod *)path:(NSString *)string
{
    return [self appendPath:string];
}

- (ClientMethod *)appendPath:(NSString *)string
{
    [_pathTemplate appendString:string];
    return self;
}

- (ClientMethod *)setObject:(id)value forPathParameter:(NSString *)key
{
    if (value != nil)
    {
        [_pathParams setObject:value forKey:key];
    } else
    {
        [_pathParams removeObjectForKey:key];
    }
    return self;
}

- (void)POST:(id)body
{
    [self POST];
}

#pragma mark - HTTP Verb

- (ClientMethod *)POST
{
    self.verb = @"POST";
    return self;
}

- (ClientMethod *)GET
{
    self.verb = @"GET";
    return self;
}

- (ClientMethod *)DELETE
{
    self.verb = @"DELETE";
    return self;
}

- (ClientMethod *)PUT
{
    self.verb = @"PUT";
    return self;
}

#pragma mark - Build

- (ClientRequest *)request
{
    ClientRequest *request = [[ClientRequest alloc] init];
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:[self.baseURI stringByAppendingString:_pathTemplate]];
    for (NSString *key in [_pathParams allKeys])
    {
        [builder setObject:[_pathParams objectForKey:key] forPathParameter:key];
    }
    for (NSString *key in [_queryParams allKeys])
    {
        [builder setObject:[_queryParams objectForKey:key] forQueryParameter:key];
    }
    request.url = [builder URL];
    if (self.verb != nil)
    {
        request.method = self.verb;
    }

    if (_body != nil)
    {
        if ([_body respondsToSelector:@selector(JSONObject)])
        {
            [request.headers setObject:@"application/json" forKey:@"Content-Type"];
            request.body = [NSJSONSerialization dataWithJSONObject:[_body JSONObject] options:kNilOptions error:nil];
            id back = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:nil];
            back = back;
        } else
        {
            @throw [NSException exceptionWithName:@"Error creating request" reason:[NSString stringWithFormat:@"Don't know how to send '%@' (%@)", _body, [_body class]] userInfo:nil];
        }
    }
    return request;
}

- (ClientMethod *)withBody:(id)body
{
    _body = body;
    return self;
}

- (ClientMethod *)setObject:(NSObject *)object forQueryParameter:(NSString *)key
{
    if (object != nil)
    {
        [_queryParams setObject:object forKey:key];
    } else
    {
        [_queryParams removeObjectForKey:key];
    }
    return self;
}

- (ClientMethod *)parameters:(NSArray *)parameters
{
    for (NSString *key in parameters)
    {
        [_queryParameterNames addObject:key];
    }
    return self;
}

/**
* Converts method and arguments to a request
*
* @dot
* digraph {
*     ClientMethod -> ClientRequest;
*     ClientArguments -> ClientRequest;
* }
* @enddot
*/
- (ClientRequest *)requestWithArguments:(ClientArguments *)arguments
{
    NSSet *expectedKeys = [self allKeys];
    NSSet *actualKeys = arguments ? [arguments allKeys] : [NSSet set];
    if (![expectedKeys isEqualToSet:actualKeys])
    {
        
        NSMutableSet *missing = [expectedKeys mutableCopy];
        [missing minusSet:actualKeys];
        NSMutableSet *superfluous = [actualKeys mutableCopy];
        [superfluous minusSet:expectedKeys];
        @throw [NSException exceptionWithName:@"Invalid arguments" reason:[NSString stringWithFormat:@"Missing: [%@] Superfluous: [%@]", [[missing allObjects] componentsJoinedByString:@", "], [[superfluous allObjects] componentsJoinedByString:@", "]] userInfo:nil];
    }

    ClientRequest *req = [[ClientRequest alloc] init];
    req.method = _verb != nil ? _verb : @"GET";
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:[_baseURI stringByAppendingString:_pathTemplate]];
    for (NSString *key in [_queryParameterNames allObjects])
    {
        [builder setObject:[arguments objectForKey:key] forQueryParameter:key];
    }
    for (NSString *key in [[self pathTemplateKeys] allObjects])
    {
        [builder setObject:[arguments objectForKey:key] forPathParameter:key];
    }
    req.urlString = [builder stringValue];

    // Add form
    if ([_formParameters count] > 0)
    {
        req.bodyContentType = @"application/x-www-form-urlencoded";
        NSMutableDictionary *formDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in _formParameters){
            id value = [arguments objectForKey:key];
            [formDictionary setObject:value forKey:key];
        }
        req.body = [[formDictionary queryString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return req;
}

- (NSSet *)pathTemplateKeys
{
    NSMutableSet *result = [NSMutableSet set];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{(\\w+)\\}" options:kNilOptions error:nil];
    NSArray *matches = [regex matchesInString:_pathTemplate options:kNilOptions range:NSMakeRange(0, [_pathTemplate length])];
    for (NSTextCheckingResult *match in matches)
    {
        [result addObject:[_pathTemplate substringWithRange:[match rangeAtIndex:1]]];
    }
    return result;
}

- (NSSet *)allKeys
{
    return [[_queryParameterNames setByAddingObjectsFromSet:[self pathTemplateKeys]] setByAddingObjectsFromSet:_formParameters];
}

- (ClientMethod *)formParameters:(NSArray *)array
{
    for (NSString *key in array)
    {
        [_formParameters addObject:key];
    }
    return self;
}

@end