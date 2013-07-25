#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface RestAssetRating : RestObject

@property NSNumber *identifier;
@property NSString *userId;
@property NSString *rating;
@property NSString *crumb;

@end