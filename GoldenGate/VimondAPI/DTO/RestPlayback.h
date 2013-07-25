#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface RestPlayback : RestObject

@property(nonatomic) NSNumber *assetId;
@property(nonatomic) NSArray *items;
@property(nonatomic) NSString *logData;

@end