//
//  ProductGroupClient.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "RestClient.h"


@class RestPlatform;
@class RestProductGroup;
@class RestCategoryList;


@interface ProductGroupClient : RestClient

- (id)initWithBaseURL:(NSString *)baseURL;


- (RestProductGroup *)productGroupWithId:(NSNumber *)productgroupId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;

- (RestCategoryList *)categoriesForProductGroupId:(NSNumber *)productgroupId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;

@end
