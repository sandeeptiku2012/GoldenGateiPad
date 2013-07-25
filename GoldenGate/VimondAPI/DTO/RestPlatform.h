#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface RestPlatform : RestObject

@property NSString *name;

+ (id)platformWithName:(NSString *)name;

- (NSString *)stringValue;

@end