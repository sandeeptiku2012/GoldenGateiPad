#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "PlayQueueClient.h"
#import "RestPlatform.h"
#import "Constants.h"
#import "RestPlaybackQueueList.h"
#import "MockClientResponse.h"
#import "ClientExecutor.h"
#import "ClientRequest.h"
#import "RestPlaybackQueue.h"

@interface PlayQueueClientTests : SenTestCase
@end

@implementation PlayQueueClientTests {
}

- (void)test_getPlayQueues
{
    PlayQueueClient *client = [[PlayQueueClient alloc] initWithBaseURL:kVimondBaseURL];
    id mock = [OCMockObject partialMockForObject:client];
    id res = [MockClientResponse responseWithJSONObject:@[@{@"playqueue":@{@"@id":@"1", @"@uri":@"/api/iptv/user/playqueues/1", @"name":@"Favorites", @"numberOfItems":@4}}, @{@"playqueue":@{@"@id":@"23", @"@uri":@"/api/iptv/user/playqueues/23", @"name":@"Test-1339844742074", @"numberOfItems":@0}}]];
    [[[mock expect] andReturn:res] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request) {
        STAssertEqualObjects(request.url.absoluteString, ([NSString stringWithFormat:@"%@/%@/user/playqueues", kVimondBaseURL, kVimondPlatform]), nil);
        STAssertEqualObjects(request.method, @"GET", nil);
        STAssertTrue([[request.headers objectForKey:@"Accept"] rangeOfString:@"json"].location != NSNotFound, nil);
        return YES;
    }]];

    RestPlaybackQueueList *result = [client getPlayQueuesForPlatform:[RestPlatform platformWithName:kVimondPlatform] error:nil];
    STAssertNotNil(result, nil);
    STAssertNotNil(result.playbackQueues, nil);
    STAssertTrue(result.count == 2, nil);
    RestPlaybackQueue *firstItem = [result objectAtIndex:0];
    STAssertEqualObjects(firstItem.name, @"Favorites", nil);
    STAssertEqualObjects(firstItem.identifier, [NSNumber numberWithLong:1], nil);
    [mock verify];
}

- (void)test_getPlayQueue
{
    PlayQueueClient *client = [[PlayQueueClient alloc] initWithBaseURL:kVimondBaseURL];
    id mock = [OCMockObject partialMockForObject:client];
    NSString *response = @"{\"playqueue\":{\"@id\":\"1\",\"name\":\"Favorites\",\"memberId\":1791838,\"autoAddEnabled\":false,\"selected\":true,\"collapsed\":false,\"sortedBy\":\"user_defined\",\"queueitem\":[{\"@indexOfItem\":\"0\",\"@id\":\"346\",\"addedByUser\":true,\"seenByUser\":false,\"addDate\":\"2012-08-31T07:14:54Z\",\"assetUri\":\"\\/api\\/iptv\\/asset\\/2177642\",\"asset\":{\"@id\":\"2177642\",\"@channelId\":\"0\",\"@categoryId\":\"247\",\"@uri\":\"\\/api\\/iptv\\/asset\\/2177642\",\"archive\":true,\"aspect16x9\":true,\"assetTypeId\":0,\"autoEncode\":false,\"autoPublish\":true,\"category\":{\"@uri\":\"\\/api\\/iptv\\/category\\/247\"},\"copyLiveStream\":false,\"createTime\":\"2012-08-22T18:11:51Z\",\"deleted\":false,\"description\":\"James Cameron and the crew talk about the technology and the innovations behind the creation of the groundbreaking visuals of Avatar. Watch cool behind-the-scenes footage of the crazy amount of cameras used, human and computing power thrown behind the capture of realistic emotions, actions, movements of the actors to bring their 'avatars' to life.\",\"distributed\":1,\"drmProtected\":false,\"duration\":276,\"encoderGroupId\":0,\"imageUrl\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/505ce25f6c4460d0b5d5cba5\\/main\",\"imageVersions\":{\"image\":{\"@type\":\"original\",\"url\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/505ce25f6c4460d0b5d5cba5\\/main\"}},\"itemsPublished\":false,\"items\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177642\\/items\"},\"live\":false,\"liveBroadcastTime\":\"2012-08-22T18:11:51Z\",\"metadata\":{\"@uri\":\"\\/api\\/metadata\\/asset\\/2177642\",\"title\":{\"@xml:lang\":\"en_US\",\"$\":\"Technology behind Avatar\"},\"description-short\":{\"@xml:lang\":\"en_US\",\"$\":\"James Cameron and the crew talk about the technology and the innovations behind the creation of the groundbreaking visuals of Avatar. Watch cool behind-the-scenes footage of the crazy amount of cameras used, human and computing power thrown behind the capt\"},\"publisher\":{\"@xml:lang\":\"*\",\"$\":\"XCSDemo\"},\"publisher-id\":{\"@xml:lang\":\"*\",\"$\":\"6\"},\"preview-asset-id\":{\"@xml:lang\":\"*\",\"$\":\"2177663\"}},\"onDemandTimeBegin\":0,\"onDemandTimeEnd\":0,\"playback\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177642\\/play\"},\"product\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177642\\/productgroups\"},\"encoderProfileId\":0,\"title\":\"Technology behind Avatar\",\"updateTime\":\"2012-09-21T21:55:48Z\",\"views\":0},\"assetName\":\"Technology behind Avatar\",\"progId\":2177642,\"txTime\":\"2012-08-22T18:11:51Z\"},{\"@indexOfItem\":\"1\",\"@id\":\"361\",\"addedByUser\":true,\"seenByUser\":false,\"addDate\":\"2012-09-04T08:39:55Z\",\"assetUri\":\"\\/api\\/iptv\\/asset\\/2177544\",\"asset\":{\"@id\":\"2177544\",\"@channelId\":\"0\",\"@categoryId\":\"247\",\"@uri\":\"\\/api\\/iptv\\/asset\\/2177544\",\"archive\":true,\"aspect16x9\":true,\"assetTypeId\":0,\"autoEncode\":false,\"autoPublish\":true,\"category\":{\"@uri\":\"\\/api\\/iptv\\/category\\/247\"},\"copyLiveStream\":false,\"createTime\":\"2012-07-27T15:50:12Z\",\"deleted\":false,\"description\":\"This is a remake of the classic.\",\"distributed\":1,\"drmProtected\":false,\"duration\":507,\"encoderGroupId\":0,\"imageUrl\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/50179edc6c4460d0b5d5c9ae\\/main\",\"imageVersions\":{\"image\":{\"@type\":\"original\",\"url\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/50179edc6c4460d0b5d5c9ae\\/main\"}},\"itemsPublished\":false,\"items\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177544\\/items\"},\"live\":false,\"liveBroadcastTime\":\"2012-07-27T15:50:12Z\",\"metadata\":{\"@uri\":\"\\/api\\/metadata\\/asset\\/2177544\",\"title\":{\"@xml:lang\":\"en_US\",\"$\":\"Jaws - Remade\"},\"description-short\":{\"@xml:lang\":\"en_US\",\"$\":\"This is a remake of the classic.\"},\"publisher\":{\"@xml:lang\":\"*\",\"$\":\"XCSDemo\"},\"publisher-id\":{\"@xml:lang\":\"*\",\"$\":\"6\"}},\"onDemandTimeBegin\":0,\"onDemandTimeEnd\":0,\"playback\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177544\\/play\"},\"product\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177544\\/productgroups\"},\"encoderProfileId\":0,\"title\":\"Jaws - Remade\",\"updateTime\":\"2012-08-31T06:35:10Z\",\"views\":0},\"assetName\":\"Jaws - Remade\",\"progId\":2177544,\"txTime\":\"2012-07-27T15:50:12Z\"},{\"@indexOfItem\":\"2\",\"@id\":\"364\",\"addedByUser\":true,\"seenByUser\":false,\"addDate\":\"2012-09-04T14:28:39Z\",\"assetUri\":\"\\/api\\/iptv\\/asset\\/2177539\",\"asset\":{\"@id\":\"2177539\",\"@channelId\":\"0\",\"@categoryId\":\"247\",\"@uri\":\"\\/api\\/iptv\\/asset\\/2177539\",\"archive\":true,\"aspect16x9\":true,\"assetTypeId\":0,\"autoEncode\":false,\"autoPublish\":true,\"category\":{\"@uri\":\"\\/api\\/iptv\\/category\\/247\"},\"copyLiveStream\":false,\"createTime\":\"2012-07-27T13:05:01Z\",\"deleted\":false,\"description\":\"Making of the movie Act of Valor\",\"distributed\":1,\"drmProtected\":false,\"duration\":320,\"encoderGroupId\":0,\"imageUrl\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/50131d3e6c4460d0b5d5c992\\/main\",\"imageVersions\":{\"image\":{\"@type\":\"original\",\"url\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/50131d3e6c4460d0b5d5c992\\/main\"}},\"itemsPublished\":false,\"items\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177539\\/items\"},\"live\":false,\"liveBroadcastTime\":\"2012-07-27T13:05:01Z\",\"metadata\":{\"@uri\":\"\\/api\\/metadata\\/asset\\/2177539\",\"title\":{\"@xml:lang\":\"en_US\",\"$\":\"Act of Valor - Making of\"},\"description-short\":{\"@xml:lang\":\"en_US\",\"$\":\"Making of the movie Act of Valor\"},\"publisher\":{\"@xml:lang\":\"*\",\"$\":\"XCSDemo\"},\"publisher-id\":{\"@xml:lang\":\"*\",\"$\":\"6\"}},\"onDemandTimeBegin\":0,\"onDemandTimeEnd\":0,\"playback\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177539\\/play\"},\"product\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177539\\/productgroups\"},\"encoderProfileId\":0,\"title\":\"Act of Valor - Making of\",\"updateTime\":\"2012-08-31T06:35:10Z\",\"views\":0},\"assetName\":\"Act of Valor - Making of\",\"progId\":2177539,\"txTime\":\"2012-07-27T13:05:01Z\"},{\"@indexOfItem\":\"3\",\"@id\":\"365\",\"addedByUser\":true,\"seenByUser\":false,\"addDate\":\"2012-09-04T15:02:21Z\",\"assetUri\":\"\\/api\\/iptv\\/asset\\/2177629\",\"asset\":{\"@id\":\"2177629\",\"@channelId\":\"0\",\"@categoryId\":\"284\",\"@uri\":\"\\/api\\/iptv\\/asset\\/2177629\",\"archive\":true,\"aspect16x9\":true,\"assetTypeId\":0,\"autoEncode\":false,\"autoPublish\":true,\"category\":{\"@uri\":\"\\/api\\/iptv\\/category\\/284\"},\"copyLiveStream\":false,\"createTime\":\"2012-08-14T10:57:16Z\",\"deleted\":false,\"description\":\"Preview to the movie Larry Crowne.\",\"distributed\":1,\"drmProtected\":false,\"duration\":315,\"encoderGroupId\":0,\"imageUrl\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/502edfd36c4460d0b5d5cab1\\/main\",\"imageVersions\":{\"image\":{\"@type\":\"original\",\"url\":\"http:\\/\\/projecthelen.net\\/api\\/image\\/502edfd36c4460d0b5d5cab1\\/main\"}},\"itemsPublished\":false,\"items\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177629\\/items\"},\"live\":false,\"liveBroadcastTime\":\"2012-08-14T10:57:16Z\",\"metadata\":{\"@uri\":\"\\/api\\/metadata\\/asset\\/2177629\",\"title\":{\"@xml:lang\":\"en_US\",\"$\":\"Larry Crowne\"},\"description-short\":{\"@xml:lang\":\"en_US\",\"$\":\"Preview to the movie Larry Crowne.\"},\"publisher-id\":{\"@xml:lang\":\"*\",\"$\":\"6\"},\"preview-asset-id\":{\"@xml:lang\":\"*\",\"$\":\"2177630\"}},\"onDemandTimeBegin\":0,\"onDemandTimeEnd\":0,\"playback\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177629\\/play\"},\"product\":{\"@uri\":\"\\/api\\/iptv\\/asset\\/2177629\\/productgroups\"},\"encoderProfileId\":0,\"title\":\"Larry Crowne\",\"updateTime\":\"2012-08-31T06:35:10Z\",\"views\":0},\"assetName\":\"Larry Crowne\",\"progId\":2177629,\"txTime\":\"2012-08-14T10:57:16Z\"}]}}";
    id res = [MockClientResponse responseWithJSONObject:[NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    [[[mock expect] andReturn:res] execute:[OCMArg checkWithBlock:^BOOL(ClientRequest *request) {
        STAssertEqualObjects(request.url.absoluteString, ([NSString stringWithFormat:@"%@/%@/user/playqueues/1", kVimondBaseURL, kVimondPlatform]), nil);
        STAssertEqualObjects(request.method, @"GET", nil);
        STAssertTrue([[request.headers objectForKey:@"Accept"] rangeOfString:@"json"].location != NSNotFound, nil);
        return YES;
    }]];
    RestPlaybackQueue *result = [client getPlayQueue:[NSNumber numberWithLong:1] platform:[RestPlatform platformWithName:kVimondPlatform] error:nil];
    STAssertNotNil(result, nil);
    [mock verify];
}

@end