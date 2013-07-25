//
//  RatingStore.h
//  GoldenGate
//
//  Created by Andreas Petrov on 11/1/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoStore;
@class SessionManager;
@class CategoryClient;
@class RestPlatform;
@class Channel;
@class Video;

@interface RatingStore : NSObject

- (id)initWithSessionManager:(SessionManager *)sessionManager
                  videoStore:(VideoStore *)videoStore
              categoryClient:(CategoryClient *)categoryClient
                    platform:(RestPlatform *)platform;

- (void)likeChannel:(Channel *)channel onSuccess:(void (^)(BOOL success))handler;
- (void)isChannelLiked:(Channel *)channel onSuccess:(void (^)(BOOL success))handler;
- (BOOL)isVideoLiked:(Video *)video error:(NSError **)error;
- (void)likeVideo:(Video *)video error:(NSError **)error;

@end
