#import "RestObject.h"
#import "RestCategoryList.h"
#import "RestCategory.h"

@implementation RestCategoryList {
}
+ (NSString *)root
{
    return @"categories";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        id category = [data objectForKey:@"category"];
        NSMutableArray *array = [NSMutableArray array];
        if ([category isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *categoryDict in category)
            {
                [array addObject:[[RestCategory alloc] initWithJSONObject:categoryDict]];
            }
        } else if ([category isKindOfClass:[NSDictionary class]])
        {
            [array addObject:[[RestCategory alloc] initWithJSONObject:category]];
        }
        self.categories = array;
    }
    return self;
}

- (id)JSONObject
{
    return [NSMutableDictionary dictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, categories = [%@]>", [self class], self, [_categories componentsJoinedByString:@", "]];
}

@end