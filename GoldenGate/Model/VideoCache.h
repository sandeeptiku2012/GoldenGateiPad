//
//  Created by Andreas Petrov on 10/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RestProgramSortBy.h"

@class Channel;

/*!
 @abstract
 Helper class for caching video list requests for channels.
 */
@interface VideoCache : NSObject

@property (readonly, nonatomic, assign) ProgramSortBy sortBy;
@property (readonly, nonatomic, assign) NSUInteger videosPrChannel;


/*!
 @abstract
 
 @param videosPrChannel specify how many videos you want to fetch for each channel.
 @param sortBy specify the sorting parameters of the videos to be cached.
 */
- (id)initWithVideosPrChannel:(NSUInteger)videosPrChannel sortBy:(ProgramSortBy)sortBy;


- (void)clearCache;

- (NSArray *)videosForChannel:(Channel *)channel;

- (BOOL)areVideosForChannelCached:(Channel *)channel;

@end