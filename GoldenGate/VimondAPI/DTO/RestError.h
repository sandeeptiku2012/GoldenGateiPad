#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestError : NSObject<JSONSerializable>

@property NSString *codeString;
@property NSString *text;
@property NSString *reference;

@end