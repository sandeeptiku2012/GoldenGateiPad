#import <SenTestingKit/SenTestingKit.h>
#import "VimondStore.h"
#import "ContentPanelStore.h"
#import "ContentCategory.h"
#import "Channel.h"
#import "FeaturedContent.h"
#import "GoldenGateTests.h"

@interface ContentPanelStoreTests : SenTestCase
@end

@implementation ContentPanelStoreTests {
}

- (void)test_noteworthy
{
    __SLOW_TEST__
    ContentPanelStore *store = [VimondStore contentPanelStore];
    ContentCategory *rootCategory = [ContentCategory new];
    rootCategory.identifier = 100;

    NSArray *channels = [store contentPanel:ContentPanelTypeNoteworthy forCategory:rootCategory error:nil];

    STAssertNotNil(channels, nil);
    for (Channel *channel in channels)
    {
        DLog(@"Channel: %@", channel);
    }
}

- (void)test_featured
{
    __SLOW_TEST__
    ContentPanelStore *store = [VimondStore contentPanelStore];
    ContentCategory *rootCategory = [ContentCategory new];
    rootCategory.identifier = 100;

    NSArray *channels = [store featuredContentPanelForCategory:rootCategory error:nil];

    STAssertNotNil(channels, nil);
    for (FeaturedContent *item in channels)
    {
        DLog(@"FeaturedContent: %@", item);
    }
}

@end