#import <Foundation/Foundation.h>

@class ClientResponse;
@class ClientRequest;

@interface ClientExecutor : NSObject

- (ClientResponse *)execute:(ClientRequest *)request;

- (id)readType:(Class)clazz fromResponse:(ClientResponse *)response error:(NSError **)error;

@end