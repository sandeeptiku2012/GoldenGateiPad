#import "PlaybackStore.h"
#import "RestPlatform.h"
#import "Video.h"
#import "Playback.h"
#import "AssetClient.h"
#import "RestPlayback.h"
#import "RestPlaybackItem.h"
#import "PlayProgressClient.h"
#import "PlayProgress.h"
#import "RestPlayProgress.h"

@implementation PlaybackStore {
    RestPlatform *_platform;
    AssetClient *_assetClient;
    PlayProgressClient *_playProgressClient;
}

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if (self = [super init])
    {
        _platform           = [RestPlatform platformWithName:platformName];
        _assetClient        = [[AssetClient alloc] initWithBaseURL:baseURL];
        _playProgressClient = [[PlayProgressClient alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (Playback *)playbackForVideo:(Video *)video error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithInt:video.identifier];
    RestPlayback *restPlayback = [_assetClient getAssetPlayback:assetId platform:_platform videoFormat:nil protocol:nil error:error];
    if (restPlayback == nil || [restPlayback.items count] < 1)
    {
        return nil;
    }
    RestPlaybackItem *playbackItem = [restPlayback.items objectAtIndex:0];

    Playback *result = [[Playback alloc] init];
    result.assetID = [restPlayback.assetId intValue];
    result.logData = restPlayback.logData;
    result.fileId = [playbackItem.fileId intValue];
    result.streamURL = playbackItem.url;
    return result;
}

- (void)logPlayback:(Playback *)playback error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithInt:playback.assetID];
    NSNumber *fileId = [NSNumber numberWithInt:playback.fileId];
    [_assetClient postLogAssetPlayback:_platform assetId:assetId fileId:fileId payload:playback.logData error:error];
}

- (PlayProgress*)playProgressForVideo:(Video *)video error:(NSError **)error
{
    RestPlayProgress *playProgress = [_playProgressClient playProgressForAssetId:@(video.identifier) platform:_platform error:error];
    PlayProgress* progress = [playProgress playProgressObject];
    progress.assetID = video.identifier;
    return progress;
}

- (void)storeProgressForVideo:(Video *)video offsetSeconds:(NSTimeInterval)offsetSeconds error:(NSError **)error
{
    [_playProgressClient putProgressForAssetId:@(video.identifier) offsetSeconds:@(offsetSeconds) platform:_platform error:error];
}


@end