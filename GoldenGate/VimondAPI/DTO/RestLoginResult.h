#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

extern NSString *kAuthenticationOk;
extern NSString *kSessionInvalidated;
extern NSString *kSessionAuthenticated;
extern NSString *kSessionNotAuthenticated;
extern NSString *kMaxRequestsReachedForHost;

@interface RestLoginResult : NSObject <JSONSerializable>

@property NSString *code;
@property NSString *text;
@property NSNumber *userId;

- (id)initWithJSONObject:(id)data;

@end