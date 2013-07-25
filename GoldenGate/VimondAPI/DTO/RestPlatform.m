#import "RestObject.h"
#import "RestPlatform.h"

@implementation RestPlatform

+ (id)platformWithName:(NSString *)name
{
    RestPlatform *result = [[RestPlatform alloc] init];
    result.name = name;
    return result;
}

- (NSString *)stringValue
{
    return self.name;
}

@end