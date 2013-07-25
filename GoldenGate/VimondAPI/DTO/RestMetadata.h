#import <Foundation/Foundation.h>

#import "RestObject.h"

@interface RestMetadata : RestObject

- (id)objectForKeyPath:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end