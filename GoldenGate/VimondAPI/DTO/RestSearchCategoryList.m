#import "RestSearchCategoryList.h"
#import "RestSearchCategory.h"

@implementation RestSearchCategoryList {
}

+ (NSString *)root
{
    return @"categories";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    { 
        self.numberOfHits = [data objectForKey:@"numberOfHits"];
        NSMutableArray *_array = [NSMutableArray array];
        id value = [data objectForKey:@"category"];
        if ([value isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *item in value)
            {
                [_array addObject:[[RestSearchCategory alloc] initWithJSONObject:item]];
            }
        }
        else if(value)
        {
            [_array addObject:[[RestSearchCategory alloc] initWithJSONObject:value]];
        }
        self.categories = _array;
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

@end
