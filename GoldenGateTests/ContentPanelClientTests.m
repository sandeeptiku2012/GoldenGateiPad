#import <SenTestingKit/SenTestingKit.h>
#import "ContentPanelClient.h"
#import "Constants.h"
#import "RestPlatform.h"
#import "GoldenGateTests.h"

@interface ContentPanelClientTests : SenTestCase
@end

@implementation ContentPanelClientTests {
}

- (void)test_getContentPanelByName
{
    __SLOW_TEST__
    ContentPanelClient *client = [[ContentPanelClient alloc] initWithBaseURL:kVimondBaseURL];
    RestContentPanel *contentPanel = [client getContentPanelByName:@"102_noteworthy" error:nil];
    STAssertNotNil(contentPanel, nil);
}

- (void)test_getExpandableContentPanelByName
{
    __SLOW_TEST__
    ContentPanelClient *client = [[ContentPanelClient alloc] initWithBaseURL:kVimondBaseURL];
    RestContentPanel *contentPanel = [client getExpandableContentPanelByName:@"102_noteworthy" platform:[RestPlatform platformWithName:kVimondPlatform] expand:nil error:nil];
    STAssertNotNil(contentPanel, nil);
}

@end