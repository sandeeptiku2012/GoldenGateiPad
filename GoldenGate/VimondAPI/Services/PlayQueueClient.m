#import "PlayQueueClient.h"
#import "RestPlaybackQueueList.h"
#import "RestPlatform.h"
#import "ClientMethod.h"
#import "ClientResponse.h"
#import "RestPlaybackQueue.h"
#import "RestPlaybackQueueItem.h"
#import "ClientArguments.h"

@implementation PlayQueueClient {
}

- (id)initWithBaseURL:(NSString *)baseURI
{
    if (self = [super init])
    {
        self.baseURI = baseURI;
    }
    return self;
}


// NOTE: The commented out method below is how this method should be implemented.


//- (RestPlaybackQueueList *)getPlayQueuesForPlatform: (RestPlatform *)platform error: (NSError **)error
//{
//    ClientMethod *method = [[[[self createMethod] GET] path:@"/{platform}/user/playqueues"] returns:[RestPlaybackQueueList class]];
//    
//    ClientArguments *arguments = [ClientArguments new];
//    [arguments setObject:platform forKey:@"platform"];
//    
//    return [self execute:method arguments:arguments error:error];
//}

- (RestPlaybackQueueList *)getPlayQueuesForPlatform:(RestPlatform *)platform error:(NSError **)error
{
    ClientMethod *method = [[[self createMethod] GET] path:@"/{platform}/user/playqueues"];
    [method setObject:platform forPathParameter:@"platform"];
    
    ClientResponse *response = [self execute:[method request]];
    
    if (!response.data) {
        return nil;
    }
    
    return [[RestPlaybackQueueList alloc] initWithJSONObject:[NSJSONSerialization JSONObjectWithData:response.data options:kNilOptions error:error]];
}

- (RestPlaybackQueue *)getPlayQueue:(NSNumber *)queueId platform:(RestPlatform *)platform error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] GET] path:@"/{platform}/user/playqueues/{queueId}"] returns:[RestPlaybackQueue class]];

    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:queueId forKey:@"queueId"];
    [arguments setObject:platform forKey:@"platform"];

    return [self execute:method arguments:arguments error:error];
}

- (RestPlaybackQueueItem *)postPlayQueueItem:(RestPlatform *)platform queueId:(NSNumber *)queueId assetId:(NSNumber *)assetId error:(NSError **)error
{
    ClientMethod *method = [[[[self createMethod] POST] path:@"/{platform}/user/playqueues/{queueId}/{assetId}"] returns:[RestPlaybackQueueItem class]];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:queueId forKey:@"queueId"];
    [arguments setObject:assetId forKey:@"assetId"];

    return [self execute:method arguments:arguments error:error];
}

- (void)deletePlayQueueItem:(id)itemId platform:(id)platform queueId:(id)queueId error:(NSError **)error
{
    ClientMethod *method = [[[self createMethod] DELETE] path:@"/{platform}/user/playqueues/{queueId}/{itemId}"];
    ClientArguments *arguments = [ClientArguments new];
    [arguments setObject:platform forKey:@"platform"];
    [arguments setObject:queueId forKey:@"queueId"];
    [arguments setObject:itemId forKey:@"itemId"];

    [self execute:method arguments:arguments error:error];
}

@end