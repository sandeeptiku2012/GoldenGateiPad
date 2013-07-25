#import "UriBuilder.h"
#import "WebUtil.h"

@implementation UriBuilder {
    NSMutableDictionary *_queryParams;
    NSMutableDictionary *_pathParameters;
}

- (id)initWithTemplate:(NSString *)template
{
    if (self = [super init])
    {
        _template = template;
        _queryParams = [NSMutableDictionary dictionary];
        _pathParameters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)stringValue
{
    NSString *result = self.template;
    NSDictionary *pp = self.pathParameters;
    for (NSString *key in [pp allKeys])
    {
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", key] withString:[self convertToString:[pp objectForKey:key]]];
    }
    NSString *query = [self query];
    if ([query length] != 0)
    {
        result = [result stringByAppendingFormat:@"?%@", query];
    }
    return result;
}

- (NSString *)convertToString:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    if ([value respondsToSelector:@selector(stringValue)])
    {
        return [value stringValue];
    }
    @throw [NSException exceptionWithName:@"Type error" reason:[NSString stringWithFormat:@"Don't know how to convert '%@' (%@) to NSString", [value description], [value class]] userInfo:nil];
}

- (NSString *)query
{
    return [_queryParams queryString];
}

- (NSURL *)URL
{
    return [NSURL URLWithString:[self stringValue]];
}

- (UriBuilder *)setObject:(NSObject *)object forQueryParameter:(NSString *)key
{
    NSString *string = [self convertToString:object];
    if (object != nil)
    {
        [_queryParams setObject:string forKey:key];
    } else
    {
        [_queryParams removeObjectForKey:key];
    }
    return self;
}

- (UriBuilder *)setObject:(NSObject *)object forPathParameter:(NSString *)parameter
{
    if (object == nil)
    {
        [_pathParameters removeObjectForKey:parameter];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        [_pathParameters setObject:object forKey:parameter];
    }
    else if ([object respondsToSelector:@selector(stringValue)])
    {
        [_pathParameters setObject:[object performSelector:@selector(stringValue)] forKey:parameter];
    }
    else
    {
        @throw [NSException exceptionWithName:@"Invalid Argument" reason:[NSString stringWithFormat:@"Can't convert '%@' to NSString", object] userInfo:nil];
    }
    return self;
}

@end