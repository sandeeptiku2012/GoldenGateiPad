//
//  ProductGroupClient.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ProductGroupClient.h"
#import "UriBuilder.h"
#import "RestProductGroup.h"
#import "ClientMethod.h"
#import "ClientArguments.h"
#import "RestCategoryList.h"

@implementation ProductGroupClient

- (UriBuilder *)builderWithTemplate:(NSString *)template
{
    NSString *pathTemplate = @"/{platform}/productgroup";
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:[[self.baseURI stringByAppendingString:pathTemplate] stringByAppendingString:template]];
    return builder;
}

- (id)initWithBaseURL:(NSString *)baseURL
{
    if (self = [super initWithBaseURL:baseURL])
    {
        self.baseURI = baseURL;
    }
    return self;
}

- (RestProductGroup *)productGroupWithId:(NSNumber *)productgroupId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] path:@"/{platform}/productgroup/{productgroupId}"] parameters:@[@"expand"]] returns:[RestProductGroup class]];
    
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:productgroupId forKey:@"productgroupId"];
    [arguments setObject:expand forKey:@"expand"];
    
    return [self execute:method arguments:arguments error:error];
}

- (RestCategoryList *)categoriesForProductGroupId:(NSNumber *)productgroupId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] path:@"/{platform}/productgroup/{productgroupId}/categories"] parameters:nil] returns:[RestCategoryList class]];
    
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:productgroupId forKey:@"productgroupId"];
    
    return [self execute:method arguments:arguments error:error];
}

@end
