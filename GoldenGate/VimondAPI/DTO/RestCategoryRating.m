#import "RestCategoryRating.h"

@implementation RestCategoryRating {
}

+ (NSString *)root
{
    return @"categoryRating";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    {
        NSNumberFormatter *f = [NSNumberFormatter new];
        self.identifier = [f numberFromString:[data objectForKey:@"@id"]];
        self.rating = [data objectForKey:@"rating"];
        self.userId = [data objectForKey:@"userId"];
    }
    return self;
}

- (id)JSONObject
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.rating forKey:@"rating"];
    [result setObject:self.categoryId forKey:@"categoryId"];
    [result setObject:self.userId forKey:@"userId"];
    return @{@"categoryRating":result};
}

@end