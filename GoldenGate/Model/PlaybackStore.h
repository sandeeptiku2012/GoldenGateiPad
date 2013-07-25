#import <Foundation/Foundation.h>

@class Playback;
@class Video;
@class PlayProgress;

@interface PlaybackStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;
- (Playback *)playbackForVideo:(Video *)video error:(NSError **)error;
- (void)logPlayback:(Playback *)playback error:(NSError **)error;

- (PlayProgress *)playProgressForVideo:(Video *)video error:(NSError **)error;
- (void)storeProgressForVideo:(Video *)video offsetSeconds:(NSTimeInterval)offsetSeconds error:(NSError **)error;

@end