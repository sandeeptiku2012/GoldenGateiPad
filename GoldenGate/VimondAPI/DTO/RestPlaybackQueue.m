#import "RestPlaybackQueue.h"
#import "RestPlaybackQueueItem.h"

@implementation RestPlaybackQueue {
}

+ (NSString *)root
{
    return @"playqueue";
}

- (id)initWithJSONObject:(NSDictionary *)data
{
    if (self = [super init])
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        self.identifier = [f numberFromString:[data objectForKey:@"@id"]];
        self.name = [data objectForKey:@"name"];

        NSArray *items = [data objectForKey:@"queueitem"];
        NSMutableArray *array = [NSMutableArray array];
        
        if ([items isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *asset in items)
            {
                [array addObject:[[RestPlaybackQueueItem alloc] initWithJSONObject:asset]];
            }
        }
        else if (items)
        {
            [array addObject:[[RestPlaybackQueueItem alloc] initWithJSONObject:items]];
        }
        

        self.queueitem = array;
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

@end