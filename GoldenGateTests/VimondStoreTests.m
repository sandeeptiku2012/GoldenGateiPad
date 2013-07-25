#import <SenTestingKit/SenTestingKit.h>
#import "GoldenGateTests.h"
#import "VimondStore.h"
#import "Channel.h"
#import "Video.h"
#import "SearchResult.h"

@interface VimondStoreTests : SenTestCase
@end

@implementation VimondStoreTests

- (void)test_myChannels
{
    __SLOW_TEST__
    VimondStore *store = [VimondStore sharedStore];
    NSArray *channels = [store myChannels:nil];
    STAssertNotNil(channels, nil);
    STAssertTrue([channels count] > 0, nil);
    for (Channel *channel in channels)
    {
        DLog(@"channel: %@", channel.title);
    }
}

- (void)test_favoriteVideos
{
    __SLOW_TEST__
    FavoriteStore *store = [VimondStore favoriteStore];
    NSArray *videos = [store favoriteVideos:nil];
    STAssertNotNil(videos, nil);
    for (Video *video in videos)
    {
        DLog(@"video: %@", video);
    }
}

- (void)test_myNewVideos
{
    __SLOW_TEST__
    VimondStore *store = [VimondStore sharedStore];
    SearchResult *videos = [store myNewVideos:0 objectsPerPage:1 error:nil];
    STAssertNotNil(videos, nil);
    STAssertNotNil(videos.items, nil);
    for (Video *video in videos.items)
    {
        DLog(@"video: %@", video);
    }
}

- (void)test_root
{
    __SLOW_TEST__
    VimondStore *store = [VimondStore sharedStore];
    NSNumber *categoryId = [store performSelector:@selector(rootCategoryId)];
    STAssertEqualObjects(categoryId, [NSNumber numberWithLong:100], nil);
}

- (void)test_findVideos_multipleHits
{
    __SLOW_TEST__
    NSUInteger numberOfObjects = 3;
    SearchExecutor *store = [VimondStore searchExecutor];
    SearchResult *result = [store findVideosWithSearchString:@"t" pageNumber:0 objectsPrPage:numberOfObjects error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue(result.totalCount > 0, nil);
    STAssertEquals(result.items.count, MIN(result.totalCount, numberOfObjects), nil);
}

- (void)test_findVideos_singleHit
{
    __SLOW_TEST__
    NSUInteger numberOfObjects = 1;
    SearchExecutor *store = [VimondStore searchExecutor];
    SearchResult *result = [store findVideosWithSearchString:@"te" pageNumber:0 objectsPrPage:numberOfObjects error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue(result.totalCount > 0, nil);
    STAssertEquals(result.items.count, MIN(result.totalCount, numberOfObjects), nil);
}

- (void)test_findChannels_multipleHits
{
    __SLOW_TEST__
    NSUInteger numberOfObjects = 3;
    SearchExecutor *store = [VimondStore searchExecutor];
    SearchResult *result = [store findChannelsWithSearchString:@"t" pageNumber:0 objectsPrPage:3 error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue(result.totalCount > 0, nil);
    STAssertEquals(result.items.count, MIN(result.totalCount, numberOfObjects), nil);
}

- (void)test_findChannels_singleHit
{
    __SLOW_TEST__
    NSUInteger numberOfObjects = 1;
    SearchExecutor *store = [VimondStore searchExecutor];
    SearchResult *result = [store findChannelsWithSearchString:@"d" pageNumber:0 objectsPrPage:numberOfObjects error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue(result.totalCount > 0, nil);
    STAssertEquals(result.items.count, MIN(result.totalCount, numberOfObjects), nil);
}

@end
