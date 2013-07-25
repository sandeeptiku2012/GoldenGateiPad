#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestCategoryRating : NSObject <JSONSerializable>

@property NSNumber *identifier;
@property NSNumber *userId;
@property NSNumber *rating;
@property NSNumber *categoryId;

@end