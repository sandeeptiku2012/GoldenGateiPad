#import <Foundation/Foundation.h>
#import "RestProgramSortBy.h"

@class RestPlatform;
@class Video;
@class User;
@class Channel;
@class Show;
@class SearchResult;
@class ContentCategory;
@class DisplayEntity;

@interface VideoStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;
- (BOOL)isLiked:(Video *)video user:(User *)user error:(NSError **)error;
- (void)like:(Video *)video user:(User *)user error:(NSError **)error;
- (void)unlike:(Video *)video user:(User *)user error:(NSError **)error;

- (SearchResult *)videosForChannel:(Channel *)channel pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error;

// function to obtain videos for a show
- (SearchResult *)videosForShow:(Show *)show pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error;
- (SearchResult *)videosForCategory:(NSString *)categoryId query:(NSString *)query text:(NSString *)text start:(NSNumber *)start size:(NSNumber *)size1 sort:(RestProgramSortBy *)sort error:(NSError **)error;
- (SearchResult *)newVideosForCategory:(ContentCategory *)category pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize error:(NSError **)error;
- (SearchResult *)popularVideosForCategory:(ContentCategory *)category pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error;
- (SearchResult *)videosForEntity:(DisplayEntity *)dispEntity pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize sortBy:(ProgramSortBy)sortBy error:(NSError **)error;


- (Video *)videoWithId:(int)videoID error:(NSError **)error;

@end