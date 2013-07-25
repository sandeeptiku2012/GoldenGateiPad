#import <Foundation/Foundation.h>

@class ClientExecutor;
@class ClientResponse;
@class ClientRequest;
@class ClientMethod;
@class ClientArguments;


//TODO: this should probably not be here
extern NSString *kAuthenticationFailedNotification;

@interface RestClient : NSObject

@property ClientExecutor *executor;
@property NSString *baseURI;

- (id)initWithBaseURL:(NSString *)baseURL;
- (ClientResponse *)execute:(ClientRequest *)request;
- (ClientMethod *)createMethod;
- (id)execute:(ClientMethod *)method arguments:(ClientArguments *)arguments error:(NSError **)error;

@end