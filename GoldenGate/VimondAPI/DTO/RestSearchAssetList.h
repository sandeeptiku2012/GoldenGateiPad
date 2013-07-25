#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RestSearchAssetList : NSObject <JSONSerializable>

@property NSNumber *numberOfHits;
@property NSArray *assets;

+ (NSString *)root;

@end