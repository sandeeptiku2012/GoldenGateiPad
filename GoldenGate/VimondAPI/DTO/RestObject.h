#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestObject : NSObject <JSONSerializable>

+ (NSString *)root;

- (id)initWithJSONObject:(id)data;
- (id)JSONObject;

@end