#import <SenTestingKit/SenTestingKit.h>
#import "ChannelStore.h"
#import "VimondStore.h"
#import "Channel.h"
#import "GoldenGateTests.h"
#import "SearchResult.h"
#import "ContentCategory.h"

@interface ChannelStoreTests : SenTestCase
@end

@implementation ChannelStoreTests {
}

- (void)test_channelWithId
{
    __SLOW_TEST__
    ChannelStore *store = [VimondStore channelStore];
    Channel *channel = [store channelWithId:175 error:nil];
    STAssertNotNil(channel, nil );
}

- (void)test_channelsFromPublisher
{
    __SLOW_TEST__
    ChannelStore *store = [VimondStore channelStore];
    SearchResult *result = [store channelsFromPublisher:@"XCSDemo" pageIndex:0 pageSize:4 sortBy:ProgramSortByDefault error:nil];
    STAssertNotNil(result, nil);
    STAssertTrue(result.totalCount > 0, nil);
    DLog(@"Showing %d of %d", result.items.count, result.totalCount);
    for (Channel *channel in result.items)
    {
        DLog(@"Channel #%d, title = %@, publisher = %@", channel.identifier, channel.title, channel.publisher);
    }
}

- (void)test_editorsPick
{
    __SLOW_TEST__
    ChannelStore *store = [VimondStore channelStore];
    ContentCategory *category = [ContentCategory new];
    category.identifier = 211;
    Channel *channel = [store editorsPickForCategory:category error:nil];
    STAssertNotNil(channel, nil);
    DLog(@"Editor's pick: %@", channel);
}

- (void)test_numberOfVideosInChannel
{
    __SLOW_TEST__
    ChannelStore *store = [VimondStore channelStore];
    Channel *channel = [Channel new];
    channel.identifier = 100;
    NSUInteger numberOfVideos = [store numberOfVideosInChannel:channel error:nil];
    DLog(@"numberOfVideos: %u", numberOfVideos);
    STAssertTrue(numberOfVideos >= 1, nil);
}
@end