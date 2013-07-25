#import "RestAssetRating.h"

@implementation RestAssetRating

+ (NSString *)root
{
    return @"rating";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        self.identifier = [data objectForKey:@"@id"];
        self.rating = [data objectForKey:@"rating"];
    }
    return self;
}

- (id)JSONObject
{
    return [super JSONObject];
}

@end