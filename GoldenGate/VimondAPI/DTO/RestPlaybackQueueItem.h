#import <Foundation/Foundation.h>
#import "RestObject.h"

@class RestAsset;

@interface RestPlaybackQueueItem : RestObject

@property NSNumber *identifier;
@property RestAsset *asset;

@end