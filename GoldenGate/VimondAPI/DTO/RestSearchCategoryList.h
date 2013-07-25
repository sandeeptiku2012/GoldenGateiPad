#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestSearchCategoryList : NSObject <JSONSerializable>

@property NSNumber *numberOfHits;
@property NSArray *categories;
+ (NSString *)root;

@end