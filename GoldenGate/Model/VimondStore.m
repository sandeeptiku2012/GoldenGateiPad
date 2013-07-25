//
//  VimondStore.m
//  GoldenGate
//
//  Created by Erik Engheim on 20.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "VimondStore.h"
#import "Constants.h"
#import "Channel.h"
#import "Show.h"
#import "Video.h"
#import "CategoryClient.h"
#import "AuthenticationClient.h"
#import "RestPlatform.h"
#import "RestProgramSortBy.h"
#import "PlayQueueClient.h"
#import "RestAsset.h"
#import "User.h"
#import "ContentPanelStore.h"
#import "UserContentClient.h"
#import "RestSearchCategory.h"
#import "PlaybackStore.h"
#import "RestSearchCategoryList.h"
#import "RestSearchAssetList.h"
#import "RestSearchAsset.h"
#import "SearchResult.h"
#import "SearchClient.h"
#import "ImageURLBuilder.h"
#import "BundleStore.h"

#define kBaseURLIndexKey @"baseURLIndex"
#define kBaseURLsKey @"BaseURLs"
#define kBaseURLsImageServiceKey @"BaseURLsImageService"

@implementation VimondStore
{
    CategoryClient *_categoryClient;
    AuthenticationClient *_authenticationClient;
    RestPlatform *_platform;
    PlayQueueClient *_playQueueClient;
    UserContentClient *_userContentClient;
    SearchClient *_searchClient;

    CategoryStore *_categoryStore;
    FavoriteStore *_favoriteStore;
    VideoStore *_videoStore;
    BundleStore *_bundleStore;
    ChannelStore *_channelStore;
    ShowStore *_showStore;
    SearchExecutor *_searchExecutor;
    ContentPanelStore *_contentPanelStore;
    PlaybackStore *_playbackStore;
    SessionManager *_sessionManager;
    RatingStore    *_ratingStore;

    ImageURLBuilder *_imageURLBuilder;

    NSString *_baseURL;
    NSString *_imageServiceBaseURL;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *baseURL   = self.baseURL;
        _platform           = [RestPlatform platformWithName:kVimondPlatform];
        _categoryClient     = [[CategoryClient alloc] initWithBaseURL:baseURL];
        _authenticationClient = [[AuthenticationClient alloc] initWithBaseURL:baseURL];
        _playQueueClient    = [[PlayQueueClient alloc] initWithBaseURL:baseURL];
        _userContentClient  = [[UserContentClient alloc] initWithBaseURL:baseURL];
        _searchClient       = [[SearchClient alloc] initWithBaseURL:baseURL];
        _categoryStore      = [[CategoryStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];
        
        _videoStore         = [[VideoStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];
        _channelStore       = [[ChannelStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];
        _bundleStore        = [[BundleStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];
        _showStore          = [[ShowStore alloc]initWithBaseURL:baseURL platformName:kVimondPlatform];
        _contentPanelStore  = [[ContentPanelStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];
        _playbackStore      = [[PlaybackStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform];

        _searchExecutor     = [[SearchExecutor alloc] initWithSearchClient:_searchClient categoryStore:_categoryStore platform:_platform];
        _sessionManager     = [[SessionManager alloc] initWithAuthenticationClient:_authenticationClient];
        _ratingStore        = [[RatingStore alloc] initWithSessionManager:_sessionManager videoStore:_videoStore categoryClient:_categoryClient platform:_platform];
        _imageURLBuilder    = [[ImageURLBuilder alloc] initWithBaseURL:self.imageServiceBaseURL platformName:kVimondPlatform];
        _favoriteStore      = [[FavoriteStore alloc] initWithBaseURL:baseURL platformName:kVimondPlatform sessionManager:_sessionManager];
    }

    return self;
}

+ (VimondStore *)sharedStore
{
    // This is a different way from standard Apple way because the Apple sanction code doesnt assume ARC and GCD exist
    // See: http://stackoverflow.com/questions/7568935/how-do-i-implement-an-objective-c-singleton-that-is-compatible-with-arc
    static VimondStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
{
    sharedInstance = [[VimondStore alloc] init];
    // Do any other initialisation stuff here
});
    return sharedInstance;
}

+ (BundleStore *)bundleStore
{
    return [VimondStore sharedStore]->_bundleStore;
}

+ (ChannelStore *)channelStore
{
    return [VimondStore sharedStore]->_channelStore;
}

+ (ShowStore *)showStore
{
    return [VimondStore sharedStore]->_showStore;
}

+ (FavoriteStore *)favoriteStore
{
    return [VimondStore sharedStore]->_favoriteStore;
}

+ (VideoStore *)videoStore
{
    return [VimondStore sharedStore]->_videoStore;
}

+ (CategoryStore *)categoryStore
{
    return [VimondStore sharedStore]->_categoryStore;
}

+ (SearchExecutor *)searchExecutor
{
    return [VimondStore sharedStore]->_searchExecutor;
}

+ (ContentPanelStore *)contentPanelStore
{
    return [VimondStore sharedStore]->_contentPanelStore;
}

+ (PlaybackStore *)playbackStore
{
    return [VimondStore sharedStore]->_playbackStore;
}

+ (SessionManager *)sessionManager
{
    return [VimondStore sharedStore]->_sessionManager;
}

+ (RatingStore*)ratingStore
{
    return [VimondStore sharedStore]->_ratingStore;
}

+ (ImageURLBuilder*)imageURLBuilder
{
    return [VimondStore sharedStore]->_imageURLBuilder;
}

#pragma mark Authentication

- (void)clearCache
{
    [_categoryStore clearCache];
    [_channelStore clearCache];
    [_showStore clearCache];
}


#pragma mark - User content


- (NSArray *)myChannels:(NSError **)error
{
    User *user = _sessionManager.currentUser;
    
    RestSearchCategoryList *res = [_userContentClient getAccessibleCategoriesForUser:user.identifier platform:_platform sort:nil start:nil size:nil query:nil error:error];
    NSMutableArray *result = [NSMutableArray array];
    for (RestSearchCategory *category in res.categories)
    {
        Channel *channel = [category channelObject];
        if (channel) {
            [_channelStore storeChannelInCache:channel];
            [result addObject:channel];
        }
        
    }
    return result;
}


// function to obtain shows for which user has subscribed for
- (NSArray *)myShows:(NSError **)error
{
    User *user = _sessionManager.currentUser;
    RestSearchCategoryList *res = [_userContentClient getAccessibleCategoriesForUser:user.identifier platform:_platform sort:nil start:nil size:nil query:@"levelName:SUB_SHOW" error:error];//@"level:SUB_SHOW"
    NSMutableArray *result = [NSMutableArray array];
    for (RestSearchCategory *category in res.categories)
    {
        Show *show = [category showsObject];
        if (show) {
            [_showStore storeShowInCache:show];
            [result addObject:show];
        }

    }
    return result;
}

- (SearchResult *)myNewVideos:(NSUInteger)pageNumber objectsPerPage:(NSUInteger)objectsPerPage error:(NSError **)error
{
    User *user = _sessionManager.currentUser;
    
    RestSearchAssetList *res = [_userContentClient getAccessibleAssetsForUser:user.identifier
                                                                     platform:_platform
                                                                         sort:[RestProgramSortBy createProgramWithEnum:ProgramSortByPublishedDateDesc]
                                                                        start:@(pageNumber)
                                                                         size:@(objectsPerPage)
                                                                        error:error];
    NSMutableArray *result = [NSMutableArray array];
    for (RestSearchAsset *asset in res.assets)
    {
        [result addObject:[asset videoObject]];
    }
    
    SearchResult *r = [SearchResult new];
    r.totalCount = [res.numberOfHits unsignedIntegerValue];
    r.items = result;
    return r;
}

- (NSArray*)baseURLArrayFromProperties
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBaseURLsKey];
}

- (NSArray*)baseURLImageServiceArrayFromProperties
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBaseURLsImageServiceKey];
}

- (NSUInteger)baseURLIndex
{
    NSNumber *index = [[NSUserDefaults standardUserDefaults]objectForKey:kBaseURLIndexKey];
    return [index unsignedIntegerValue];
}

- (void)setBaseURLIndex:(NSUInteger)index
{
    [[NSUserDefaults standardUserDefaults]setObject:@(index) forKey:kBaseURLIndexKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // Invalidate _baseURL if index has changed.
    _baseURL = nil;
    _imageServiceBaseURL = nil;
}

- (NSString*)baseURL
{
    if (_baseURL == nil)
    {
#if TESTING
        NSUInteger index = [self baseURLIndex];
        _baseURL = self.baseURLArrayFromProperties[index];
#else
        _baseURL = kVimondBaseURL;
#endif
    }
    
    return _baseURL;
}

- (NSString*)imageServiceBaseURL
{
    if (_imageServiceBaseURL == nil)
    {
#ifdef TESTING
        NSUInteger index = [self baseURLIndex];
        _imageServiceBaseURL = self.baseURLImageServiceArrayFromProperties[index];
#else
        _imageServiceBaseURL = kVimondBaseImageServiceURL;
#endif
    }
    
    return _imageServiceBaseURL;
}

@end
