#import <SenTestingKit/SenTestingKit.h>
#import "VideoStore.h"
#import "Constants.h"
#import "Video.h"
#import "User.h"
#import "GoldenGateTests.h"
#import "AuthenticationClient.h"
#import "RestLoginResult.h"
#import "Channel.h"
#import "SearchResult.h"
#import "VimondStore.h"
#import "ContentCategory.h"

@interface VideoStoreTests : SenTestCase {
    VideoStore *_store;
}
@end

static NSNumber *userId;

@implementation VideoStoreTests

+ (void)setUp
{
    __SLOW_TEST__
    userId = [[[AuthenticationClient alloc] initWithBaseURL:kVimondBaseURL] loginWithUsername:@"demo1" password:@"demo" rememberMe:YES].userId;
}

- (void)setUp
{
    _store = [[VideoStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform];
}

- (void)test_like
{
    __SLOW_TEST__
    Video *video = [[Video alloc] init];
    video.identifier = 2177642;
    User *user = [User userWithId:userId];

    [_store like:video user:user error:nil];

    STAssertTrue( [_store isLiked:video user:user error:nil], nil);
}

- (void)test_unlike
{
    __SLOW_TEST__
    Video *video = [[Video alloc] init];
    video.identifier = 2177642;
    User *user = [User userWithId:userId];
    [_store unlike:video user:user error:nil];

    // BUG: This API call doesn't work. It always returns status 500
    // STAssertFalse( [_store isLiked:video user:user error:nil], nil);
}

- (void)test_videosForChannel
{
    __SLOW_TEST__
    Channel *channel = [[Channel alloc] init];
    channel.identifier = 100;

    SearchResult *result = [_store videosForChannel:channel pageIndex:0 pageSize:1 sortBy:ProgramSortByAssetTitleAsc error:nil];

    STAssertNotNil(result, nil);
}

- (void)test_newVideosForCategory
{
    __SLOW_TEST__
    VideoStore *store = [VimondStore videoStore];
    ContentCategory *category = [ContentCategory new];
    category.identifier = 100;
    SearchResult *result = [store newVideosForCategory:category pageIndex:0 pageSize:3 error:nil];
    STAssertNotNil(result, nil);
    for (Video *video in result.items)
    {
        DLog(@"Video: %@", video);
    }
}

- (void)test_videoWithId
{
    __SLOW_TEST__
    VideoStore *store = [VimondStore videoStore];
    Video *video = [store videoWithId:2177642 error:nil];
    STAssertNotNil(video, nil);
    DLog(@"video: %@, preview = %d", video, video.previewAssetId);
}

@end