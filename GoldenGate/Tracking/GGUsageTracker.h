//
//  Created by Andreas Petrov on 11/29/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UsageTracker.h"

@class Video;
@class Channel;
@class NavAction;


/*!
 @abstract
 This class provides an abstract interface for tracking usage events throughout the app.
 
 Whenever a new tracking method is needed please expand this class with new GGUsageEvent in the .m file.
 and add another easy to use method in the interface.
 */
@interface GGUsageTracker : UsageTracker

+ (GGUsageTracker *)sharedInstance;

- (void)trackLikeVideo:(Video*)video;
- (void)trackPlayVideo:(Video*)video preview:(BOOL)preview;
- (void)trackPlaybackFailed:(Video *)video;
- (void)trackLikeChannel:(Channel*)channel;
- (void)trackPlayback:(Video *)video duration:(NSTimeInterval)duration;
- (void)trackFavoriteVideo:(Video *)video;

@end


