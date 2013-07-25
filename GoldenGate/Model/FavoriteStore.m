#import "FavoriteStore.h"
#import "PlayQueueClient.h"
#import "Constants.h"
#import "RestPlatform.h"
#import "RestAsset.h"
#import "RestPlaybackQueue.h"
#import "RestPlaybackQueueItem.h"
#import "SessionManager.h"

#define kFavoritePlayQueueIdKey @"favoritePlayQueueId"

@interface FavoriteStore ()
{
    PlayQueueClient *_playQueueClient;
    RestPlatform *_platform;
    NSNumber *_favoriteQueueId;
    SessionManager *_sessionManager;
}
@end

@implementation FavoriteStore

- (id)initWithBaseURL:(NSString *)string platformName:(NSString *)name sessionManager:(SessionManager *)manager
{
    if (self = [super init])
    {
        _playQueueClient = [[PlayQueueClient alloc] initWithBaseURL:string];
        _platform = [RestPlatform platformWithName:name];
        _sessionManager = manager;
    }
    return self;
}


- (NSNumber *)favoritePlayQueueId:(NSError **)error
{
    NSNumber *playQueueId = [_sessionManager sessionValueForKey:kFavoritePlayQueueIdKey];

    if (playQueueId == nil)
    {
        RestPlaybackQueueList *list = [_playQueueClient getPlayQueuesForPlatform:_platform error:error];
        for (RestPlaybackQueue *queue in (id <NSFastEnumeration>) list)
        {
            if ([queue.name caseInsensitiveCompare:@"favorites"] == NSOrderedSame)
            {
                [_sessionManager setSessionValue:queue.identifier forKey:kFavoritePlayQueueIdKey];
                return queue.identifier;
            }
        }

        if (error != nil)
        {
            *error = [NSError errorWithDomain:kVimondErrorDomain code:9999 userInfo:@{@"reason" : @"Couldn't find favorite playqueue"}];
        }
    }

    return playQueueId;
}

- (NSArray *)allObjects:(NSError **)error
{
    NSMutableArray *array = [NSMutableArray array];
    NSNumber *playQueueId = [self favoritePlayQueueId:error];
    if (playQueueId != nil)
    {
        RestPlaybackQueue *queue = [_playQueueClient getPlayQueue:playQueueId platform:_platform error:error];
        for (RestPlaybackQueueItem *item in queue.queueitem)
        {
            [array addObject:[item.asset videoObject]];
        }
    }
    return array;
}

- (void)addObject:(Video *)video error:(NSError **)error
{
    assert(video != nil);
    assert(video.identifier > 0);

    NSNumber *playQueueId = [self favoritePlayQueueId:error];
    if (playQueueId != nil)
    {
        [_playQueueClient postPlayQueueItem:_platform queueId:playQueueId assetId:[NSNumber numberWithLongLong:video.identifier] error:error];
    }
}

- (void)removeObject:(Video *)video error:(NSError **)error
{
    assert(video != nil);
    assert(video.identifier > 0);

    NSNumber *assetId = [NSNumber numberWithLongLong:video.identifier];
    NSNumber *playQueueId = [self favoritePlayQueueId:error];
    if (playQueueId != nil)
    {
        RestPlaybackQueue *queue = [_playQueueClient getPlayQueue:playQueueId platform:_platform error:error];
        for (RestPlaybackQueueItem *item in queue.queueitem)
        {
            if ([assetId isEqualToNumber:item.asset.identifier])
            {
                [_playQueueClient deletePlayQueueItem:item.identifier platform:_platform queueId:playQueueId error:error];
            }
        }
    }
}

- (BOOL)contains:(Video *)video error:(NSError **)error
{
    NSNumber *assetId = [NSNumber numberWithLongLong:video.identifier];
    NSNumber *playQueueId = [self favoritePlayQueueId:error];
    if (error != nil && *error != nil)
    {
        DLog(@"error: %@", *error);
        return NO;
    }

    RestPlaybackQueue *queue = [_playQueueClient getPlayQueue:playQueueId platform:_platform error:error];
    for (RestPlaybackQueueItem *item in queue.queueitem)
    {
        if ([assetId isEqualToNumber:item.asset.identifier])
        {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)favoriteVideos:(NSError **)error
{
    return [self allObjects:error];
}

- (void)addToFavorites:(Video *)video error:(NSError **)error
{
    [self addObject:video error:error];
}

- (void)removeFromFavorites:(Video *)video error:(NSError **)error
{
    [self removeObject:video error:error];
}

- (BOOL)isFavorite:(Video *)video error:(NSError **)error
{
    return [self contains:video error:error];
}

- (void)clearPlayQueueId
{
    _favoriteQueueId = nil;
}

@end