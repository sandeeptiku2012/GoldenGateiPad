#import "RestPlaybackItem.h"

@implementation RestPlaybackItem {
}

+ (NSString *)root
{
    return @"item";
}

- (id)initWithJSONObject:(id)data
{
    self = [super initWithJSONObject:data];
    if (self)
    {
        self.url = [data objectForKey:@"url"];
        self.fileId = [data objectForKey:@"fileId"];
        self.mediaFormat = [data objectForKey:@"mediaFormat"];
    }

    return self;
}

@end