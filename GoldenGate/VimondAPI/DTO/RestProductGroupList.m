//
//  RestProductGroupList.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "RestProductGroupList.h"
#import "RestProductGroup.h"

@implementation RestProductGroupList

+ (NSString *)root
{
    return @"productGroup";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super initWithJSONObject:data])
    {
        id productGroup = [data objectForKey:@"productGroup"];
        NSMutableArray *array = [NSMutableArray array];
        if ([productGroup isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *productGroupDict in productGroup)
            {
                [array addObject:[[RestProductGroup alloc] initWithJSONObject:productGroupDict]];
            }
        } else if ([productGroup isKindOfClass:[NSDictionary class]])
        {
            [array addObject:[[RestProductGroup alloc] initWithJSONObject:productGroup]];
        }
        self.productgroups = array;
    }
    return self;
}

- (id)JSONObject
{
    return [NSMutableDictionary dictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, productgroups = [%@]>", [self class], self, [_productgroups componentsJoinedByString:@", "]];
}


@end
