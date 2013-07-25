#import <Foundation/Foundation.h>

@interface UriBuilder : NSObject

@property(nonatomic) NSString *template;
@property(nonatomic) NSDictionary *pathParameters;
@property(nonatomic) NSDictionary *queryParameters;

- (id)initWithTemplate:(NSString *)string;

- (NSString *)stringValue;
- (NSURL *)URL;

- (UriBuilder *)setObject:(NSObject *)object forQueryParameter:(NSString *)key;
- (UriBuilder *)setObject:(NSObject *)object forPathParameter:(NSString *)parameter;

@end