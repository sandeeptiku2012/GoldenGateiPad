#import <Foundation/Foundation.h>

@interface MediaType : NSObject

@property (readonly) NSString *typeName;
@property (readonly) NSString *subTypeName;
@property (readonly) NSDictionary *parameters;

- (BOOL)isCompatibleWith:(MediaType *)other;

+ (MediaType *)mediaTypeFromString:(NSString *)value;
+ (MediaType *)mediaTypeWithTypeName:(NSString *)typeName subTypeName:(NSString *)subTypeName;

+ (MediaType *)xml;
+ (MediaType *)textPlain;
+ (MediaType *)json;
+ (MediaType *)binary;
+ (MediaType *)form;
+ (MediaType *)wildcard;

@end