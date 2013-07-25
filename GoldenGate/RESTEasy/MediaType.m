#import "MediaType.h"

@implementation MediaType

- (id)initWithTypeName:(NSString *)typeName subTypeName:(NSString *)subTypeName parameters:(NSDictionary *)parameters
{
    if (self = [super init]) {
        _typeName = typeName;
        _subTypeName = subTypeName;
        _parameters = parameters;
    }
    return self;
}

- (id)initWithTypeName:(NSString *)typeName subTypeName:(NSString *)subTypeName
{
    return [self initWithTypeName:typeName subTypeName:subTypeName parameters:nil];
}

- (BOOL)isCompatibleWith:(MediaType *)other
{
    if (other != nil) {
        if ([_typeName isEqualToString:@"*"]) {
            return YES;
        }
        if ([other->_typeName isEqualToString:@"*"]) {
            return YES;
        }
        if ([_typeName caseInsensitiveCompare:other->_typeName] == NSOrderedSame) {
            if ([_subTypeName isEqualToString:@"*"]) {
                return YES;
            }
            if ([other->_subTypeName isEqualToString:@"*"]) {
                return YES;
            }
            if ([_subTypeName caseInsensitiveCompare:other->_subTypeName] == NSOrderedSame) {
                return YES;
            }
        }
    }
    return NO;
}

+ (MediaType *)mediaTypeWithTypeName:(NSString *)typeName subTypeName:(NSString *)subTypeName
{
    return [[MediaType alloc] initWithTypeName:typeName subTypeName:subTypeName];
}

+ (MediaType *)mediaTypeFromString:(NSString *)value
{
    NSArray *p = [value componentsSeparatedByString:@";"];
    NSArray *params = [p subarrayWithRange:NSMakeRange(1, [p count] - 1)];
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    for (NSString *parameter in params) {
        NSArray *pair = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[pair objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *val = [[pair objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [parameterDictionary setObject:val forKey:key];
    }
    NSArray *contentTypeArray = [[p objectAtIndex:0] componentsSeparatedByString:@"/"];
    return [[MediaType alloc] initWithTypeName:[contentTypeArray objectAtIndex:0] subTypeName:[contentTypeArray objectAtIndex:1] parameters:parameterDictionary];
}

+ (MediaType *)xml
{
    return [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"xml"];
}

+ (MediaType *)textPlain
{
    return [MediaType mediaTypeWithTypeName:@"text" subTypeName:@"plain"];
}

+ (MediaType *)json
{
    return [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"json"];
}

+ (MediaType *)binary
{
    return [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"octet-stream"];
}

+ (MediaType *)form
{
    return [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"x-www-form-urlencoded"];
}

+ (MediaType *)wildcard
{
    return [MediaType mediaTypeWithTypeName:@"*" subTypeName:@"*"];
}

@end