#import "RestContentPanel.h"
#import "RestContentPanelElement.h"

@implementation RestContentPanel {
}

+ (NSString *)root
{
    return @"contentPanelElements";
}

- (id)initWithJSONObject:(id)data
{
    
    self = [super initWithJSONObject:data];
    if (self)
    {
        
        id list = [data objectForKey:@"contentPanelElement"];
        
        NSMutableArray *items = [NSMutableArray array];
        if ([list isKindOfClass:[NSArray class]])
        {
            for (id item in list) {
                [items addObject:[[RestContentPanelElement alloc] initWithJSONObject:item]];
            }
        }
        else if (list)
        {
            [items addObject:[[RestContentPanelElement alloc] initWithJSONObject:list]];
        }
        
        _contentPanelElements = items;
    }

    return self;
}

- (id)JSONObject
{
    return [super JSONObject];
}

@end