#import "User.h"

@implementation User

- (id)initWithId:(NSNumber *)userId
{
    if (self = [self init]) {
        _identifier = userId;
    }
    return self;
}

+ (User *)userWithId:(NSNumber *)number
{
    return [[User alloc] initWithId:number];
}

@end