#import <Foundation/Foundation.h>
#import "ClientResponse.h"

@interface MockClientResponse : ClientResponse

+(id)responseWithJSONObject:(id)object;

@end