#import <Foundation/Foundation.h>

@class ClientRequest;
@class RestProgramSortBy;
@class ClientArguments;

@interface ClientMethod : NSObject

@property Class returnType;
@property NSString *pathTemplate;
@property NSString *verb;

@property(nonatomic, copy) NSString *baseURI;

- (id)init;
- (ClientMethod *)returns:(Class)clazz;
- (ClientMethod *)BaseURI:(NSString *)string;
- (ClientMethod *)path:(NSString *)string;
- (ClientMethod *)setObject:(NSObject *)value forPathParameter:(NSString *)key;
- (ClientRequest *)request;

- (void)POST:(id)body;
- (ClientMethod *)POST;
- (ClientMethod *)GET;
- (ClientMethod *)DELETE;
- (ClientMethod *)PUT;

- (ClientMethod *)withBody:(id)body;

- (ClientMethod *)setObject:(NSObject *)object forQueryParameter:(NSString *)key;

- (ClientMethod *)parameters:(NSArray *)array;

- (ClientRequest *)requestWithArguments:(ClientArguments *)arguments;
- (ClientMethod *)formParameters:(NSArray *)array;

@end