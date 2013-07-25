#import "RestObject.h"
#import "RestCategory.h"
#import "ContentCategory.h"
#import "RestMetadata.h"
#import "Channel.h"

@implementation RestCategory {
}

+ (NSString *)root
{
    return @"category";
}

- (RestCategory *)initWithJSONObject:(NSDictionary *)data
{
    if (self = [super initWithJSONObject:data])
    {

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterNoStyle];
        self.identifier = [formatter numberFromString:[data objectForKey:@"@id"]];

        self.title = [data objectForKey:@"title"];
        self.level = [data objectForKey:@"level"];
        self.parentId = [data objectForKey:@"parentId"];
        self.voteCount = [data objectForKey:@"voteCount"];
        self.metadata = [[RestMetadata alloc] initWithJSONObject:[data objectForKey:@"metadata"]];
        
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

- (ContentCategory *)categoryObject
{
    ContentCategory *result = [[ContentCategory alloc] init];
    result.identifier = [self.identifier intValue];
    result.title = [self.metadata objectForKey:@"title"] ? : self.title;
    result.categoryLevel = [self categoryLevelFromString:self.level];
    result.parentId = [self.parentId integerValue];
    return result;
}

- (ContentCategoryLevel)categoryLevelFromString:(NSString *)string
{
    ContentCategoryLevel result = ContentCategoryLevelUnknown;

    if ([string isEqualToString:@"CATEGORY"])
    {
        result = ContentCategoryLevelSub;
    }
    else if ([string isEqualToString:@"MAIN_CATEGORY"])
    {
        result = ContentCategoryLevelMain;
    }
    else if ([string isEqualToString:@"TOP_LEVEL"])
    {
        result = ContentCategoryLevelTop;
    }
    else if ([string isEqualToString:@"SHOW"])
    {
        result = ContentCategoryLevelChannel;
    }
    else if ([string isEqualToString:@"SUB_SHOW"])
    {
        result = ContentCategoryLevelShow;
    }

    return result;
}


@end