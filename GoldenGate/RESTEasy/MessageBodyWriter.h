@class MediaType;

@protocol MessageBodyWriter <NSObject>

- (BOOL)canWrite:(Class)clazz mediaType:(MediaType *)mediaType;
- (NSData *)write:(id)obj mediaType:(MediaType *)mediaType;

@end