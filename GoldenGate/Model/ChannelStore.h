#import <Foundation/Foundation.h>
#import "RestProgramSortBy.h"

@class SearchResult;
@class ContentCategory;
@class Channel;

@interface ChannelStore : NSObject

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

// Searches
- (SearchResult *)channelsForCategory:(ContentCategory *)category
                            pageIndex:(NSUInteger)pageIndex
                             pageSize:(NSUInteger)pageSize
                               sortBy:(ProgramSortBy)sortBy
                                error:(NSError **)error;

- (SearchResult *)newChannelsForCategory:(ContentCategory *)category
                               pageIndex:(NSUInteger)pageIndex
                                pageSize:(NSUInteger)pageSize
                                   error:(NSError **)error;

- (SearchResult *)mostSubscribedChannelsForCategory:(ContentCategory *)category
                                          pageIndex:(NSUInteger)pageIndex
                                           pageSize:(NSUInteger)pageSize
                                             sortBy:(ProgramSortBy)sortBy
                                              error:(NSError **)error;


- (SearchResult *)channelsFromPublisher:(NSString *)publisher
                              pageIndex:(NSUInteger)pageIndex
                               pageSize:(NSUInteger)pageSize
                                 sortBy:(ProgramSortBy)sort
                                  error:(NSError **)error;

- (Channel *)channelWithId:(NSUInteger)channelId error:(NSError **)error;
- (Channel *)editorsPickForCategory:(ContentCategory *)category error:(NSError **)error;
- (NSUInteger)numberOfVideosInChannel:(Channel *)channel error:(NSError **)error;


// Caching
- (void)clearCache;

- (void)storeChannelInCache:(Channel *)channel;

- (void)invalidateCacheForChannel:(Channel *)channel;

@end