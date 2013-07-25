#import "UserContentClient.h"
#import "RestSearchCategoryList.h"
#import "RestPlatform.h"
#import "RestProgramSortBy.h"
#import "ClientMethod.h"
#import "RestSearchAssetList.h"
#import "ClientArguments.h"

@implementation UserContentClient {
}


- (RestSearchCategoryList *)getAccessibleCategoriesForUser:(NSNumber *)userId platform:(RestPlatform *)platform sort:(RestProgramSortBy *)sort start:(NSNumber *)start size:(NSNumber *)size query:(NSString*)query error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] path:@"/{platform}/user/{userId}/access/categories"] parameters:@[@"sort", @"start", @"size", @"query"]] returns:[RestSearchCategoryList class]];
    
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:userId forKey:@"userId"];
    
    [arguments setObject:sort forKey:@"sort"];
    [arguments setObject:start forKey:@"start"];
    [arguments setObject:size forKey:@"size"];
    [arguments setObject:query forKey:@"query"];
    
    return [self execute:method arguments:arguments error:error];
}

- (RestSearchAssetList *)getAccessibleAssetsForUser:(NSNumber *)userId
                                           platform:(RestPlatform *)platform
                                               sort:(RestProgramSortBy *)sort
                                              start:(NSNumber *)start
                                               size:(NSNumber *)size
                                              error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] path:@"/{platform}/user/{userId}/access/assets"] parameters:@[@"query", @"sort", @"start", @"size"]] returns:[RestSearchAssetList class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:userId forKey:@"userId"];


    [arguments setObject:sort forKey:@"sort"];
    [arguments setObject:start forKey:@"start"];
    [arguments setObject:size forKey:@"size"];
    
    NSString *query = @"publish:[NOW-7DAYS TO NOW]";
    [arguments setObject:query forKey:@"query"];
    
    return [self execute:method arguments:arguments error:error];
}

@end
