#import "RestError.h"

@implementation RestError {
}
+ (NSString *)root
{
    return @"error";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init]) {

    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

@end