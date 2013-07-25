#import "SearchClient.h"
#import "RestPlatform.h"
#import "RestSearchAssetList.h"
#import "RestSearchCategoryList.h"
#import "ClientMethod.h"
#import "ClientArguments.h"

@implementation SearchClient {
}

- (id)initWithBaseURI:(NSString *)string executor:(id)executor
{
    if (self = [super init])
    {
        self.baseURI = string;
        self.executor = executor;
    }
    return self;
}

- (RestSearchAssetList *)getAssetsForPlatform:(RestPlatform *)platform
                                  subCategory:(NSString *)subCategory
                                        query:(NSString *)query
                                         sort:(RestProgramSortBy *)sortBy
                                        start:(NSNumber *)start
                                         size:(NSNumber *)size
                                         text:(NSString *)text
                                        error:(NSError **)error
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/search/{subCategory}"] parameters:@[@"query", @"sort", @"start", @"size", @"text"]] returns:[RestSearchAssetList class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:subCategory forKey:@"subCategory"];

    [arguments setObject:query forKey:@"query"];
    [arguments setObject:sortBy forKey:@"sort"];
    [arguments setObject:start forKey:@"start"];
    [arguments setObject:size forKey:@"size"];
    [arguments setObject:text forKey:@"text"];

    return [self execute:method arguments:arguments error:error];
}

- (RestSearchCategoryList *)getCategoriesForPlatform:(RestPlatform *)platform
                                         subCategory:(NSString *)subCategory
                                               query:(NSString *)query
                                                sort:(RestProgramSortBy *)sortBy
                                               start:(NSNumber *)start
                                                size:(NSNumber *)size
                                                text:(NSString *)text
                                               error:(NSError **)error
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/search/categories/{subCategory}"] parameters:@[@"start", @"size", @"sort", @"query", @"text"]] returns:[RestSearchCategoryList class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:subCategory forKey:@"subCategory"];

    [arguments setObject:query forKey:@"query"];
    [arguments setObject:sortBy forKey:@"sort"];
    [arguments setObject:start forKey:@"start"];
    [arguments setObject:size forKey:@"size"];
    [arguments setObject:text forKey:@"text"];

    return [self execute:method arguments:arguments error:error];
}

@end