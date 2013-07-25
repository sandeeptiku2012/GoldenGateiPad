#import "RestEntity.h"
#import "WebUtil.h"

@implementation RestEntity {
}

- (id)initWithJSONObject:(id)object
{
    if ([super conformsToProtocol:@protocol(JSONSerializable)]) {
        self = [super initWithJSONObject:object];
    } else {
        self = [self init];
    }
    if (self != nil) {
        id o = [[object allValues] lastObject];
        self.identifier = [NSNumber numberWithLongLong:[[o objectForKeyPath:@"@id"] longLongValue]];
    }
    return self;
}

@end