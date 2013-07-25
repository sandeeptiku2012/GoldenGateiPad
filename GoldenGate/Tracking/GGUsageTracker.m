//
//  Created by Andreas Petrov on 11/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "GGUsageTracker.h"
#import "GATrackerProxy.h"
#import "GAITracker.h"
#import "GAI.h"
#import "UsageEventTemplate.h"
#import "Video.h"
#import "Channel.h"
#import "TFTracker.h"
#import "FilterAction.h"

// IF 1 then we'll use Knowit's google analytics. Set to 0 before making test-flight.
#define USE_INTERNAL_GA 0

#if TESTING

// used earlier to segregate google analytics data capture while testing and otherwise
#if USE_INTERNAL_GA
//#define kGoogleAnalyticsUA  @"UA-36193134-2" 
#else
//#define kGoogleAnalyticsUA  @"UA-33184060-2" 
#endif

#define kGASampleRate       100
#define kGADispatchInterval 30
#else
//#define kGoogleAnalyticsUA  @"UA-33184060-2" 
#define kGASampleRate       90.0
#define kGADispatchInterval 120
#endif

#define kGoogleAnalyticsUA   @"UA-41820721-2" 
#define kTestFlightTeamToken    @"d903e201d4acea0e349d60c383e8d13c_MTQ5NTk0MjAxMi0xMC0zMCAxOTo0NTo1NS44MTUyODI"
#define kTestFlightAppToken @"53cd30e6-d920-4616-a335-08aa290bc3a2"

#define kEventCategoryVideoPlayer @"videoPlayer"
#define kEventCategoryUserRating @"userRating"
#define kLabelKey @"identifier"
#define kDurationKey @"duration"
#define kPageViewKey @"pageView";

@interface GGUsageTracker ()

@property (strong, nonatomic) NSDictionary *eventActionNameDict;
@property (strong, nonatomic) NSDictionary *eventCategoryNameDict;

typedef enum
{
    GGUsageEventAssetPlayback,
    GGUsageEventAssetPlaybackDuration,
    GGUsageEventAssetPlaybackFailed,
    GGUsageEventAssetPreview,
    GGUsageEventAssetLiked,
    GGUsageEventAssetFavorited,
    GGUsageEventChannelLiked
} GGUsageEvent;

@end

@implementation GGUsageTracker
{

}

+ (GGUsageTracker *)sharedInstance
{
    static GGUsageTracker *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (NSString*)identifierFromEntity:(Entity*)entity
{
    return [NSString stringWithFormat:@"[%d] %@",entity.identifier, entity.title];
}

- (void)trackLikeVideo:(Video *)video
{
    if (!video) return;
    
    [self trackEvent:GGUsageEventAssetLiked eventData:@{kLabelKey : [self identifierFromEntity:video]}];
}

- (void)trackPlayVideo:(Video *)video preview:(BOOL)preview
{
    if (!video) return;

    GGUsageEvent event = preview ? GGUsageEventAssetPreview : GGUsageEventAssetPlayback;

    [self trackEvent:event eventData:@{kLabelKey : [self identifierFromEntity:video]}];
}

- (void)trackPlaybackFailed:(Video *)video
{
    if (!video) return;
    
    [self trackEvent:GGUsageEventAssetPlaybackFailed eventData:@{kLabelKey : [self identifierFromEntity:video]}];
}

- (void)trackLikeChannel:(Channel *)channel
{
    if (!channel) return;
    
    [self trackEvent:GGUsageEventChannelLiked eventData:@{kLabelKey : [self identifierFromEntity:channel]}];
}

- (void)trackPlayback:(Video *)video duration:(NSTimeInterval)duration
{
    if (!video) return;
    
    [self trackTiming:GGUsageEventAssetPlaybackDuration eventData:@{kLabelKey : [self identifierFromEntity:video], kDurationKey : @(duration)}];
}

- (void)trackFavoriteVideo:(Video *)video
{
    if (!video) return;
    
    [self trackEvent:GGUsageEventAssetFavorited eventData:@{kLabelKey : [self identifierFromEntity:video]}];
}


- (id)init
{
    if ((self = [super init]))
    {
        [self setupGoogleAnalytics];
#if TESTING
        [self registerUsageTracker:[TFTracker createTrackerWithTeamToken:kTestFlightAppToken] withName:@"TestFlight"];
#endif
        [self registerEventTemplates];
    }

    return self;
}

- (void)setupGoogleAnalytics
{
    GATrackerProxy *proxy = [GATrackerProxy createWithUACode:kGoogleAnalyticsUA makeDefault:YES];
    proxy.googleTracker.anonymize = YES;
    proxy.googleTracker.sampleRate = kGASampleRate;
    [self registerUsageTracker:proxy withName:@"GoogleAnalytics"];
    [GAI sharedInstance].dispatchInterval = kGADispatchInterval;
}

- (void)registerEventTemplates
{
    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetPlayback)
                                                                           categoryName:kEventCategoryVideoPlayer
                                                                             actionName:@"assetPlayback"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetPlaybackDuration)
                                                                           categoryName:kEventCategoryVideoPlayer
                                                                             actionName:@"assetPlaybackDuration"
                                                                               labelKey:kLabelKey
                                                                               valueKey:kDurationKey]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetPlaybackFailed)
                                                                           categoryName:kEventCategoryVideoPlayer
                                                                             actionName:@"assetPlaybackFailed"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetPreview)
                                                                           categoryName:kEventCategoryVideoPlayer
                                                                             actionName:@"assetPreview"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetLiked)
                                                                           categoryName:kEventCategoryUserRating
                                                                             actionName:@"assetLiked"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventAssetFavorited)
                                                                           categoryName:kEventCategoryUserRating
                                                                             actionName:@"assetFavorited"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];

    [self registerEventTemplate:[UsageEventTemplate createUsageEventTemplateWithEventId:@(GGUsageEventChannelLiked)
                                                                           categoryName:kEventCategoryUserRating
                                                                             actionName:@"channelLiked"
                                                                               labelKey:kLabelKey
                                                                               valueKey:nil]];
}


@end
