//
//  RatingStore.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/1/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "RatingStore.h"
#import "VideoStore.h"
#import "SessionManager.h"
#import "Channel.h"
#import "RestCategoryRating.h"
#import "CategoryClient.h"
#import "User.h"
#import "RestPlatform.h"
#import "Video.h"

@interface RatingStore()

@property (weak, nonatomic) SessionManager *sessionManager;
@property (weak, nonatomic) VideoStore *videoStore;
@property (weak, nonatomic) CategoryClient *categoryClient;
@property (weak, nonatomic) RestPlatform *platform;

@end

@implementation RatingStore

- (id)initWithSessionManager:(SessionManager *)sessionManager
                  videoStore:(VideoStore *)videoStore
              categoryClient:(CategoryClient *)categoryClient
                    platform:(RestPlatform *)platform
{
    if ((self = [super init]))
    {
        _sessionManager = sessionManager;
        _videoStore = videoStore;
        _categoryClient = categoryClient;
        _platform = platform;
    }

    return self;
}

- (void)likeChannel:(Channel *)channel onSuccess:(void (^)(BOOL success))handler
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperationQueue *main = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^
     {
         NSNumber *categoryId = [NSNumber numberWithLong:channel.identifier];
         User *user = _sessionManager.currentUser;
         NSError *error = nil;
         RestCategoryRating *r = [_categoryClient getRatingByUser:user.identifier
                                                       categoryId:categoryId
                                                         platform:_platform
                                                            error:&error];
         BOOL hasNotBeenLikedYet = [r identifier] == nil;
         if (hasNotBeenLikedYet)
         {
             RestCategoryRating *rating = [[RestCategoryRating alloc] init];
             rating.userId = user.identifier;
             rating.rating = [NSNumber numberWithLong:5];
             rating.categoryId = categoryId;
             [_categoryClient postRating:rating categoryId:categoryId platform:_platform];
             [main addOperationWithBlock:^
              {
                  handler(YES);
              }];
         }
     }];
}

- (void)isChannelLiked:(Channel *)channel onSuccess:(void (^)(BOOL isLiked))handler
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperationQueue *main = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^
     {
         NSNumber *categoryId = [NSNumber numberWithLong:channel.identifier];
         BOOL isLiked = [_categoryClient getRatingByUser:_sessionManager.currentUser.identifier
                                              categoryId:categoryId
                                                platform:_platform error:nil].identifier != nil;
         [main addOperationWithBlock:^
          {
              handler(isLiked);
          }];
     }];
}

- (BOOL)isVideoLiked:(Video *)video error:(NSError **)error
{
    return [_videoStore isLiked:video user:_sessionManager.currentUser error:error];
}

- (void)likeVideo:(Video *)video error:(NSError **)error
{
    [_videoStore like:video user:_sessionManager.currentUser error:error];
}


@end
