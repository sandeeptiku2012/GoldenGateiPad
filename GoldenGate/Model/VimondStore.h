//
//  VimondStore.h
//  GoldenGate
//
//  Created by Erik Engheim on 20.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Channel;
@class SearchResult;
@class Video;
@class SearchExecutor;
@class ContentPanelStore;
@class PlaybackStore;
@class ImageURLBuilder;
@class BundleStore;

// Not forward declaring these because we want
// to be able to just include VimondStore in other files.
#import "VideoStore.h"
#import "FavoriteStore.h"
#import "ChannelStore.h"
#import "ShowStore.h"
#import "CategoryStore.h"
#import "SearchExecutor.h"
#import "SessionManager.h"
#import "RatingStore.h"

#import "BlockDefinitions.h"
#import "RestProgramSortBy.h"

@interface VimondStore : NSObject

+ (VimondStore*)sharedStore;

+ (ChannelStore*)channelStore;
+ (BundleStore*)bundleStore;
+ (ShowStore*)showStore;
+ (FavoriteStore*)favoriteStore;
+ (VideoStore*)videoStore;
+ (CategoryStore*)categoryStore;
+ (SearchExecutor*)searchExecutor;
+ (ContentPanelStore *)contentPanelStore;
+ (PlaybackStore *)playbackStore;
+ (SessionManager *)sessionManager;
+ (RatingStore*)ratingStore;
+ (ImageURLBuilder*)imageURLBuilder;

- (void)clearCache;

// TODO REFACTOR OUT FROM HERE
- (NSArray *)myChannels:(NSError **)error;

// vimond store function to obtain subscribed shows
- (NSArray*)myShows:(NSError **)error;
- (SearchResult *)myNewVideos:(NSUInteger)pageNumber objectsPerPage:(NSUInteger)objectsPerPage error:(NSError **)error;

- (NSString*)baseURL;
- (NSString*)imageServiceBaseURL;

// For DEBUG and TESTING only.
- (NSArray*)baseURLArrayFromProperties;
- (NSArray*)baseURLImageServiceArrayFromProperties;

@property (assign, nonatomic) NSUInteger baseURLIndex;

@end
