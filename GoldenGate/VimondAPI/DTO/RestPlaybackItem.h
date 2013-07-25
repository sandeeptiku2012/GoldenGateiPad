#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface RestPlaybackItem : RestObject

@property(nonatomic) NSString *url;
@property(nonatomic) NSNumber *fileId;
@property (nonatomic)NSString *mediaFormat;

@end