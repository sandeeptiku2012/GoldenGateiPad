#import "FormMessageBodyWriter.h"
#import "MediaType.h"
#import "WebUtil.h"

NSString *getString(id obj)
{
    if (obj == nil || obj == [NSNull null])
    {
        return nil;
    }
    if ([obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    if ([obj respondsToSelector:@selector(stringValue)])
    {
        return [obj stringValue];
    }
    @throw [NSException exceptionWithName:@"Invalid argument exception" reason:[NSString stringWithFormat:@"Cannot convert %@ to NSString", obj] userInfo:nil];
}

@implementation FormMessageBodyWriter {
}
- (BOOL)canWrite:(Class)clazz mediaType:(MediaType *)mediaType
{
    if (![mediaType isCompatibleWith:[MediaType form]])
    {
        return NO;
    }
    if ([clazz isSubclassOfClass:[NSDictionary class]])
    {
        return YES;
    }
    return NO;
}

- (NSData *)write:(id)object mediaType:(MediaType *)mediaType
{
    if ([[object class] isSubclassOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            NSString *str = getString(obj);
            if (str)
            {
                [d setObject:str forKey:key];
            }
        }];
        return [[d queryString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end