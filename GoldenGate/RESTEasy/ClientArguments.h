#import <Foundation/Foundation.h>

@interface ClientArguments : NSObject

- (void)setObject:(id)number forKey:(NSString *)key;
- (BOOL)containsKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (NSSet *)allKeys;

@end