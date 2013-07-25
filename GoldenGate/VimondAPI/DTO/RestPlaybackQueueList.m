#import "RestPlaybackQueueList.h"
#import "RestPlaybackQueue.h"

@implementation RestPlaybackQueueList {
}

+ (NSString *)root
{
    return @"playqueues";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *child in data)
        {
            if ([child isKindOfClass:[NSDictionary class]])
            {
                [arr addObject:[[RestPlaybackQueue alloc] initWithJSONObject:[child objectForKey:@"playqueue"]]];
            }
        }
        self.playbackQueues = arr;
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

- (RestPlaybackQueue *)objectAtIndex:(NSUInteger)index
{
    return [_playbackQueues objectAtIndex:index];
}

- (NSUInteger)count
{
    return [_playbackQueues count];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len
{
    return [_playbackQueues countByEnumeratingWithState:state objects:buffer count:len];
}

@end