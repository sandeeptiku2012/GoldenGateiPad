//
//  Created by Andreas Petrov on 10/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "VideoCache.h"
#import "VimondStore.h"
#import "Channel.h"
#import "SearchResult.h"

@interface VideoCache()

@property (strong, nonatomic) NSCache *videoCache;


@end

@implementation VideoCache


- (id)initWithVideosPrChannel:(NSUInteger)videosPrChannel sortBy:(ProgramSortBy)sortBy
{
    if ((self = [super init]))
    {
        _videoCache = [NSCache new];
        _videosPrChannel = videosPrChannel;
        _sortBy = sortBy;
    }

    return self;
}

- (void)clearCache
{
    [_videoCache removeAllObjects];
}

- (NSArray *)videosForChannel:(Channel *)channel
{
    if (channel == nil)
    {
        return nil;
    }
    
    NSNumber *identifier = @(channel.identifier);
    NSArray *videos = [self.videoCache objectForKey:identifier];
    BOOL notInCache = videos == nil;
    if (notInCache)
    {
        SearchResult *searchResult = [[VimondStore videoStore] videosForChannel:channel
                                                                      pageIndex:0
                                                                       pageSize:self.videosPrChannel
                                                                         sortBy:self.sortBy
                                                                          error:nil];
        videos = searchResult.items;
        [self.videoCache setObject:videos forKey:identifier];
    }

    return videos;
}

- (BOOL)areVideosForChannelCached:(Channel *)channel
{
    if (channel == nil)
    {
        return NO;
    }
    
    NSNumber *identifier = @(channel.identifier);
    NSArray *videos = nil;
    if (identifier)
    {
        videos = [self.videoCache objectForKey:identifier];
    }

    return videos != nil;
}


@end