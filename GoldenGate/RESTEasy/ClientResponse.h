#import <Foundation/Foundation.h>

@interface ClientResponse : NSObject

@property NSData *data;
@property NSMutableDictionary *headers;
@property NSInteger statusCode;
@property NSError *error;

- (id)initWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error;

- (BOOL)isSuccess;
@end