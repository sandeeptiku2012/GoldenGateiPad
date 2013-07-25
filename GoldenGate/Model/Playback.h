#import <Foundation/Foundation.h>

@interface Playback : NSObject

@property (nonatomic) int assetID;
@property (nonatomic) NSString *streamURL;
@property (nonatomic) int fileId;
@property (nonatomic) NSString *logData;

@end