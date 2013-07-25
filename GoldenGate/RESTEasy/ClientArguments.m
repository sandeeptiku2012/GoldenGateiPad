#import "ClientArguments.h"

@implementation ClientArguments {
    NSMutableDictionary *_arguments;
}

- (id)init
{
    if (self = [super init])
    {
        _arguments = [NSMutableDictionary new];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [_arguments setObject:object != nil ? object : ([NSNull null]) forKey:key];
}

- (BOOL)containsKey:(NSString *)key
{
    return [[_arguments allKeys] containsObject:key];
}

- (id)objectForKey:(NSString *)key
{
    id value = [_arguments objectForKey:key];
    return value != [NSNull null] ? value : nil;
}

- (NSSet *)allKeys
{
    return [NSSet setWithArray:[_arguments allKeys]];
}

@end