//
//  RestProductGroup.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "RestProductGroup.h"
#import "RestMetadata.h"
#import "Bundle.h"

@implementation RestProductGroup

+ (NSString *)root
{
    return @"productGroup";
}


- (RestProductGroup *)initWithJSONObject:(NSDictionary *)data
{
    if (self = [super initWithJSONObject:data])
    {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterNoStyle];
        self.identifier = [formatter numberFromString:[data objectForKey:@"@id"]];
        
        self.title = [data objectForKey:@"name"];
        self.summary = [data objectForKey:@"description"];
        self.accessType = [data objectForKey:@"accessType"];
        self.salesStatus = [data objectForKey:@"saleStatus"];

        self.metadata = [[RestMetadata alloc] initWithJSONObject:[data objectForKey:@"metadata"]];
    }
    return self;
}

- (id)JSONObject
{
    return nil;
}

- (Bundle*)bundleObject
{
    Bundle* bundle = [Bundle new];
    bundle.identifier = [self.identifier integerValue];
    bundle.title = self.title;
    bundle.summary = self.summary;
    if ([self.accessType isEqualToString:@"PAID"]) {
        bundle.isPaid = YES;
    }else{
        bundle.isPaid = NO;
    }
    if([self.salesStatus isEqualToString:@"ENABLED"])
    {
        bundle.isSaleEnabled = YES;
    }else{
        bundle.isSaleEnabled = NO;
    }
    bundle.publisher = [self.metadata objectForKey:@"publisher"];
    bundle.imagePack = [self.metadata objectForKey:@"image-pack"];
    
    return bundle;    
}


@end
