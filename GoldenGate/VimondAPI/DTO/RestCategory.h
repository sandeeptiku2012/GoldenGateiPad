#import <Foundation/Foundation.h>
#import "RestObject.h"

@class ContentCategory;
@class RestMetadata;

@interface RestCategory : RestObject

@property NSNumber *identifier;
@property NSNumber *parentId;
@property NSString *title;
@property NSString *level;
@property NSNumber *voteCount;

@property RestMetadata *metadata;

- (id)initWithJSONObject:(id)data;
- (ContentCategory *)categoryObject;


@end