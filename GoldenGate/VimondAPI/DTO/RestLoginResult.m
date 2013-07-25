#import "RestLoginResult.h"

// codes from Vimond API for authentication checks
NSString *kAuthenticationOk = @"AUTHENTICATION_OK"; // Get this when login is successful
NSString *kSessionInvalidated = @"SESSION_INVALIDATED"; // When logout is performed and successful
NSString *kSessionAuthenticated = @"SESSION_AUTHENTICATED"; // When you check state and you are logged in
NSString *kSessionNotAuthenticated = @"SESSION_NOT_AUTHENTICATED"; // When you check state and you are logged in

@implementation RestLoginResult {
}
+ (NSString *)root
{
    return @"response";
}

- (id)initWithJSONObject:(id)data
{
    if (self = [super init])
    {
        self.code = [data objectForKey:@"code"];
        self.text = [data objectForKey:@"description"];
        self.userId = [data objectForKey:@"userId"];
    }

    return self;
}

- (id)JSONObject
{
    return [NSMutableDictionary dictionary];
}

@end