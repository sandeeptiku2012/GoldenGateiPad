#import <SenTestingKit/SenTestingKit.h>
#import "FavoriteStore.h"
#import "Constants.h"
#import "GoldenGateTests.h"
#import "Video.h"
#import "AuthenticationClient.h"

@interface FavoriteStoreTests : SenTestCase
@end

@implementation FavoriteStoreTests {
}

+ (void)setUp
{
    __SLOW_TEST__
    [[[AuthenticationClient alloc] initWithBaseURL:kVimondBaseURL] loginWithUsername:@"demo1" password:@"demo" rememberMe:YES];
}

- (void)test_favoritePlayQueueId
{
    __SLOW_TEST__
    FavoriteStore *store = [[FavoriteStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform sessionManager:NULL];
    NSNumber *playQueueId = [store performSelector:@selector(favoritePlayQueueId:) withObject:nil];

    DLog(@"playQueueId: %@", playQueueId);
    STAssertNotNil(playQueueId, nil);
}

- (void)test_contains
{
    __SLOW_TEST__
    FavoriteStore *store = [[FavoriteStore alloc] initWithBaseURL:kVimondBaseURL platformName:kVimondPlatform sessionManager:NULL];

    Video *video = [[Video alloc] init];
    video.identifier = 12345;
    NSError *error = nil;
    BOOL result = [store isFavorite:video error:&error];

    STAssertNil(error, nil);
    STAssertFalse(result, nil);
}

@end