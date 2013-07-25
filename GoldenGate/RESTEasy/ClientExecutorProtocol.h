@class ClientRequest;
@class ClientResponse;

@protocol ClientExecutorProtocol <NSObject>

- (void)execute:(ClientRequest *)request onSuccess:(void (^)(id result))successHandler onError:(void (^)(NSError *error))errorHandler;
- (ClientResponse *)execute:(ClientRequest *)request;

@end