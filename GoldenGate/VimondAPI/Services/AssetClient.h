#import <Foundation/Foundation.h>
#import "RestClient.h"

@class Video;
@class RestAssetRating;
@class RestPlatform;
@class RestAsset;
@class RestPlayback;

@interface AssetClient : RestClient

- (RestAsset *)getAsset:(NSNumber *)assetId platform:(RestPlatform *)platform expand:(NSString *)expand error:(NSError **)error;
- (RestPlayback *)getAssetPlayback:(NSNumber *)assetId platform:(RestPlatform *)platform videoFormat:(NSString *)videoFormat protocol:(NSString *)protocol error:(NSError **)error;
- (void)postLogAssetPlayback:(RestPlatform *)platform assetId:(NSNumber *)assetId fileId:(NSNumber *)fileId payload:(NSString *)payload error:(NSError **)error;
- (RestAssetRating *)postAssetRating:(RestAssetRating *)rating platform:(RestPlatform *)platform assetId:(NSNumber *)assetId error:(NSError **)error;
- (void)deleteAssetRating:(id)platform assetId:(id)assetId ratingId:(id)ratingId error:(NSError **)error;
- (RestAssetRating *)getRatingForUser:(id)platform assetId:(id)assetId userId:(id)userId error:(NSError **)error;

@end