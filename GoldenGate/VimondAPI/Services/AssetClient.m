#import "AssetClient.h"
#import "RestAssetRating.h"
#import "ClientRequest.h"
#import "ClientExecutor.h"
#import "RestPlatform.h"
#import "ClientResponse.h"
#import "UriBuilder.h"
#import "RestAsset.h"
#import "ClientMethod.h"
#import "RestPlayback.h"
#import "ClientArguments.h"

@implementation AssetClient

- (RestAsset *)getAsset:(NSNumber *)assetId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/asset/{assetId}"] parameters:@[@"expand"]] returns:[RestAsset class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:assetId forKey:@"assetId"];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:expand forKey:@"expand"];

    return [self execute:method arguments:arguments error:error];
}

- (RestPlayback *)getAssetPlayback:(NSNumber *)assetId
                          platform:(RestPlatform *)platform
                       videoFormat:(NSString *)videoFormat
                          protocol:(NSString *)protocol
                             error:(NSError **)error
{
    ClientMethod *method = [[[[[self createMethod] GET] path:@"/{platform}/asset/{assetId}/play"] parameters:@[@"videoFormat", @"protocol"]] returns:[RestPlayback class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:assetId forKey:@"assetId"];

    [arguments setObject:videoFormat forKey:@"videoFormat"];
    [arguments setObject:protocol forKey:@"protocol"];

    return [self execute:method arguments:arguments error:error];
}

- (void)postLogAssetPlayback:(RestPlatform *)platform assetId:(NSNumber *)assetId fileId:(NSNumber *)fileId payload:(NSString *)payload error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] POST] formParameters:@[@"payload"]] path:@"/{platform}/asset/{assetId}/play/log/{fileId}/"];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:assetId forKey:@"assetId"];
    [arguments setObject:fileId forKey:@"fileId"];
    [arguments setObject:payload forKey:@"payload"];

    [self execute:method arguments:arguments error:error];
}

- (RestAssetRating *)postAssetRating:(RestAssetRating *)rating platform:(RestPlatform *)platform assetId:(NSNumber *)assetId error:(NSError **)error
{
    NSString *template = @"/{platform}/asset/{assetId}/rating";
    ClientRequest *request = [[ClientRequest alloc] init];
    UriBuilder *builder = [[UriBuilder alloc] initWithTemplate:[self.baseURI stringByAppendingString:template]];
    builder.pathParameters = @{@"platform":platform, @"assetId":assetId};
    request.url = [builder URL];
    request.method = @"POST";
    [request.headers setObject:@"application/json" forKey:@"Accept"];
    [request.headers setObject:@"application/json" forKey:@"Content-Type"];
    request.body = [NSJSONSerialization dataWithJSONObject:[rating JSONObject] options:kNilOptions error:error];

    ClientResponse *response = [self.executor execute:request];
    return [self.executor readType:[RestAssetRating class] fromResponse:response error:error];
}

- (void)deleteAssetRating:(id)platform assetId:(id)assetId ratingId:(id)ratingId error:(NSError **)error
{
    ClientMethod *method = [[[self createMethod] DELETE] path:@"/{platform}/asset/{assetId}/rating/{ratingId}"];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:assetId forKey:@"assetId"];
    [arguments setObject:ratingId forKey:@"ratingId"];

    [self execute:method arguments:arguments error:error];
}

- (RestAssetRating *)getRatingForUser:(id)platform assetId:(id)assetId userId:(id)userId error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] GET] path:@"/{platform}/asset/{assetId}/ratingForUser/{userId}"] returns:[RestAssetRating class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:assetId forKey:@"assetId"];
    [arguments setObject:userId forKey:@"userId"];

    return [self execute:method arguments:arguments error:error];
}
@end