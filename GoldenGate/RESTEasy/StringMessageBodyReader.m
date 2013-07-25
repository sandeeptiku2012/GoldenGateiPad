#import "StringMessageBodyReader.h"
#import "MediaType.h"

@interface StringMessageBodyReader ()

- (BOOL)canReadClass:(Class)clazz mediaType:(MediaType *)contentType;

@end

@implementation StringMessageBodyReader

- (BOOL)canReadClass:(Class)clazz mediaType:(MediaType *)contentType
{
    if (clazz != [NSString class])
    {
        return NO;
    }

    if (![contentType isCompatibleWith:[MediaType textPlain]])
    {
        return NO;
    }
    return YES;
}

- (id)read:(Class)clazz mediaType:(MediaType *)mediaType from:(id)object
{
    if (object == nil)
    {
        return nil;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    if ([object isKindOfClass:[NSData class]])
    {
        return [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
    }
    if ([object respondsToSelector:@selector(stringValue)])
    {
        return [object stringValue];
    }
    return nil;
}

@end