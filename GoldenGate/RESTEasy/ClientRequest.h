#import <Foundation/Foundation.h>

@interface ClientRequest : NSObject

@property(nonatomic) NSURL *url;
@property(nonatomic) NSString *urlString;
@property NSString *method;
@property NSData *body;
@property NSString *bodyContentType;

@property NSMutableDictionary *headers;
@property NSMutableDictionary *pathParameters;
@property NSMutableDictionary *formParameters;
@property NSMutableDictionary *queryParameters;

- (void)POST;

@end