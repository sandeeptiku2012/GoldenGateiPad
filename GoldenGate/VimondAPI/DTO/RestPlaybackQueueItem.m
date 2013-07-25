#import "JSONSerializable.h"
#import "RestPlaybackQueueItem.h"
#import "RestAsset.h"

@implementation RestPlaybackQueueItem {
}
- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        self.asset = [[RestAsset alloc] initWithJSONObject:[data objectForKey:@"asset"]];
        self.identifier = [formatter numberFromString:[data objectForKey:@"@id"]];
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

@end