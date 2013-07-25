#import <Foundation/Foundation.h>
#import "RestCategory.h"

@class RestMetadata;

@interface RestSearchCategory : RestCategory

- (id)channelObject;
// function to return object for shows
- (id)showsObject;

- (id)entityObject;

@end