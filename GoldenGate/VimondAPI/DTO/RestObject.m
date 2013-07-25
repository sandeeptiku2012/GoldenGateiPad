#import <objc/runtime.h>
#import "RestObject.h"

@implementation RestObject

+ (NSString *)root
{
    return [NSString stringWithCString:class_getName([self class]) encoding:NSASCIIStringEncoding];
}

- (id)initWithJSONObject:(id)data
{
    return data ? [self init] : nil;
}

- (id)JSONObject
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    u_int count;
    objc_property_t *propList = class_copyPropertyList([self class], &count);
    for (u_int i = 0; i < count; i++)
    {
        objc_property_t property = propList[i];
        const char *propName = property_getName(property);
        NSString *propNameString = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        id value = [self valueForKey:propNameString];
        if (value != nil)
        {
            [result setValue:value forKey:propNameString];
        }
    }
    free(propList);
    return [NSDictionary dictionaryWithObject:result forKey:[[self class] root]];
}

+ (NSString*)stringFromMetaData:(NSDictionary*)metadata forKey:(id)key
{
    NSString *string = nil;
    id object = [metadata objectForKey:key];
    if ([object isKindOfClass:[NSArray class]])
    {
        // TODO: Might want to fetch the string with the correct language in the future.
        string = [[object objectAtIndex:0]objectForKey:@"$"];
    }
    else
    {
        string = object;
    }
    
    return string;
}

@end