@protocol JSONSerializable <NSObject>

+ (NSString *)root;
- (id)initWithJSONObject:(id)data;
- (id)JSONObject;

@end