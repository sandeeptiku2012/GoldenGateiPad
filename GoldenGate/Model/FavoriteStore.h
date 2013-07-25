#import <Foundation/Foundation.h>

@class Video;
@class SessionManager;

@interface FavoriteStore : NSObject

- (id)initWithBaseURL:(NSString *)string platformName:(NSString *)name sessionManager:(SessionManager *)manager;

- (NSArray *)favoriteVideos:(NSError **)error;
- (void)addToFavorites:(Video *)video error:(NSError **)error;
- (void)removeFromFavorites:(Video *)video error:(NSError **)error;
- (BOOL)isFavorite:(Video *)video error:(NSError **)error;

@end