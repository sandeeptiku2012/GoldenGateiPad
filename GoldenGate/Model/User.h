#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, readonly) NSNumber *identifier;

- (id)initWithId:(NSNumber *)userId;

+ (User *)userWithId:(NSNumber *)number;

@end