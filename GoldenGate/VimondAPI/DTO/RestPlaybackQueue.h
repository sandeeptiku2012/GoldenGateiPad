#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestPlaybackQueue : NSObject <JSONSerializable>

@property NSNumber *identifier;
@property NSString *name;
@property NSArray *queueitem;

@end