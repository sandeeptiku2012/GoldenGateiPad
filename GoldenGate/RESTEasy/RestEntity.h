#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface RestEntity : RestObject <JSONSerializable>

@property NSNumber *identifier;

- (id)initWithJSONObject:(id)object;

@end