#import <Foundation/Foundation.h>
#import "Video.h"

@class RestMetadata;

@interface RestAsset : NSObject <JSONSerializable>

@property NSNumber *identifier;
//@property NSNumber *categoryId;
@property NSNumber *views;
@property NSString *title;
@property NSDate *liveBroadcastTime;
@property NSNumber *duration;
@property NSNumber *voteCount;
@property NSDate *publishedDate;
@property RestMetadata *metadata;
@property NSNumber *categoryID;

+ (NSString *)root;
- (Video *)videoObject;

@end