#import <Foundation/Foundation.h>
#import "ClientExecutorProtocol.h"
#import "ClientExecutor.h"

@class ClientResponse;
@class ClientRequest;

@interface GoldenGateClientExecutor : ClientExecutor

- (ClientResponse *)execute:(ClientRequest *)request;

@end