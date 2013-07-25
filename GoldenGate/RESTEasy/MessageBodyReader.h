@class MediaType;

@protocol MessageBodyReader <NSObject>

-(BOOL)canReadClass:(Class)clazz mediaType:(MediaType *)mediaType;
-(id)read:(Class)clazz mediaType:(MediaType *)mediaType from:(id)object;

@end