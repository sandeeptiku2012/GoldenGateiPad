#import "JSONMessageBodyWriter.h"
#import "MediaType.h"
#import "JSONSerializable.h"

@implementation JSONMessageBodyWriter {
}
- (BOOL)canWrite:(Class)clazz mediaType:(MediaType *)mediaType
{
    if (![mediaType isCompatibleWith:[MediaType json]])
    {
        return NO;
    }
    if ([clazz conformsToProtocol:@protocol(JSONSerializable)])
    {
        return YES;
    }
    return NO;
}

- (id)write:(id)obj mediaType:(MediaType *)mediaType
{
    return nil;
}

@end