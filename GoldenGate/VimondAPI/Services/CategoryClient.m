#import "CategoryClient.h"
#import "RestPlatform.h"
#import "RestCategory.h"
#import "UriBuilder.h"
#import "ClientRequest.h"
#import "ClientExecutor.h"
#import "ClientResponse.h"
#import "RestCategoryList.h"
#import "RestCategoryRating.h"
#import "ClientMethod.h"
#import "ClientArguments.h"

@implementation CategoryClient {
}

- (UriBuilder *)builderWithTemplate:(NSString *)template
{
    NSString *pathTemplate = @"/{platform}/category";
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

- (RestCategory *)rootCategoryForPlatform:(RestPlatform *)platform error:(NSError **)error
{
    assert(platform != nil);

    ClientMethod *method = [[[[self createMethod] GET] path:@"/{platform}/category/root"] returns:[RestCategory class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];

    return [self execute:method arguments:arguments error:error];
}

- (RestCategory *)categoryWithId:(NSNumber *)categoryId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] path:@"/{platform}/category/{categoryId}"] parameters:@[@"expand"]] returns:[RestCategory class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:categoryId forKey:@"categoryId"];
    [arguments setObject:expand forKey:@"expand"];

    return [self execute:method arguments:arguments error:error];
}

- (RestCategoryList *)subCategoriesForCategoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/category/{categoryId}/categories"] parameters:@[@"expand"]] returns:[RestCategoryList class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:categoryId forKey:@"categoryId"];
    [arguments setObject:expand forKey:@"expand"];

    return [self execute:method arguments:arguments error:error];
}

- (RestCategoryRating *)postRating:(RestCategoryRating *)rating categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform
{
    ClientMethod *method = [[[[self createMethod] POST] path:@"/{platform}/category/{categoryId}/rating/"] returns:[RestCategoryRating class]];
    [method setObject:platform forPathParameter:@"platform"];
    [method setObject:categoryId forPathParameter:@"categoryId"];
    [method withBody:rating];
    [method returns:[RestCategoryRating class]];
    return [self invokeMethod:method];
}

- (RestCategoryRating *)getRatingByUser:(NSNumber *)userId categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] GET] path:@"/{platform}/category/{categoryId}/ratingForUser/{userId}"] returns:[RestCategoryRating class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:categoryId forKey:@"categoryId"];
    [arguments setObject:userId forKey:@"userId"];

    return [self execute:method arguments:arguments error:error];
}

- (void)deleteRating:(NSNumber *)ratingId categoryId:(NSNumber *)categoryId platform:(RestPlatform *)platform error:(NSError **)error
{
    ClientMethod *method = [[[self createMethod] DELETE] path:@"/{platform}/category/{categoryId}/rating/{ratingId}"];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:ratingId forKey:@"ratingId"];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:categoryId forKey:@"categoryId"];

    [self execute:method arguments:arguments error:error];
}

- (id)invokeMethod:(ClientMethod *)method
{
    ClientResponse *response = [self.executor execute:[method request]];
    return response;
}

@end