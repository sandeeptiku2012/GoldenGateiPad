#import "RestSearchAssetList.h"
#import "RestAsset.h"
#import "RestSearchAsset.h"

@implementation RestSearchAssetList {
}

+ (NSString *)root
{
    return @"assets";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    {
        NSMutableArray *tmp = [NSMutableArray array];
        id assets = [data objectForKey:@"asset"];
        if ([assets isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *asset in assets)
            {
                [tmp addObject:[[RestSearchAsset alloc] initWithJSONObject:asset]];
            }
        }
        else if(assets)
        {
            [tmp addObject:[[RestSearchAsset alloc] initWithJSONObject:assets]];
        }
        self.assets = tmp;
        self.numberOfHits = [data objectForKey:@"numberOfHits"];
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

@end