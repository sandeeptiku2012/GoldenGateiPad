#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestPlatform;
@class RestPlaybackQueue;
@class RestPlaybackQueueItem;
@class RestPlaybackQueueList;

@interface PlayQueueClient : RestClient

- (id)initWithBaseURL:(NSString *)baseURI;

- (RestPlaybackQueueList *)getPlayQueuesForPlatform:(RestPlatform *)platform error:(NSError **)error;
- (RestPlaybackQueue *)getPlayQueue:(NSNumber *)queueId platform:(RestPlatform *)platform error:(NSError **)error;
- (RestPlaybackQueueItem *)postPlayQueueItem:(RestPlatform *)platform queueId:(NSNumber *)queueId assetId:(NSNumber *)assetId error:(NSError **)error;
- (void)deletePlayQueueItem:(id)itemId platform:(id)platform queueId:(id)queueId error:(NSError **)error;

@end