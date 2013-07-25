#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@class RestPlaybackQueue;

@interface RestPlaybackQueueList : NSObject <JSONSerializable, NSFastEnumeration>

@property NSArray *playbackQueues;

- (RestPlaybackQueue *)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;

@end