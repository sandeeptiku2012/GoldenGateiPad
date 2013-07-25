#import "RestPlayback.h"
#import "RestPlaybackItem.h"

@implementation RestPlayback {
}

+ (NSString *)root
{
    return @"playback";
}

- (id)initWithJSONObject:(id)data
{
    self = [super initWithJSONObject:data];
    if (self)
    {
        self.assetId = [data objectForKey:@"@assetId"];
        self.logData = [data objectForKey:@"logData"];
        self.items = [self readItems:[data objectForKey:@"items"]];
    }

    return self;
}

- (NSMutableArray *)readItems:(id)data
{
    NSMutableArray *array = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]])
    {
        for (id child in data)
        {
            [self appendItems:array data:child];
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        [self appendItems:array data:data];
    }
    return array;
}

- (void)appendItems:(NSMutableArray *)temp data:(id)items
{
    id itemObject = [items objectForKey:[RestPlaybackItem root]];
    if ([itemObject isKindOfClass:[NSArray class]])
    {
        for (id child in itemObject)
        {
            if ([child isKindOfClass:[NSDictionary class]])
            {
                [self appendItem:temp data:child];
            }
        }
    }
    else if ([itemObject isKindOfClass:[NSDictionary class]])
    {
        [self appendItem:temp data:itemObject];
    }
}

- (void)appendItem:(NSMutableArray *)array data:(id)data
{
    [array addObject:[[RestPlaybackItem alloc] initWithJSONObject:data]];
}

@end