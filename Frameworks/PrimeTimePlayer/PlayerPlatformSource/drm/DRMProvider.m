//
//  DRMProvider.m
// PlayerPlatform
//
//  Created by Cory Zachman on 10/5/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "DRMProvider.h"
#import "PTWorkflow.h"
#import "PTOLWorkflow.h"
#import "Asset.h"
#import "PlayerPlatformVideoEvent.h"
#import "PlayerPlatformDrmFailureEventData.h"
#import <drmNativeInterface/DRMInterface.h>
@interface DRMProvider()
{
    DRMWorkFlowType _drmWorkFlowType;
}
@end
@implementation DRMProvider

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static DRMProvider *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[DRMProvider alloc] init];
        }
        
        return sharedSingleton;
    }
}

-(void)initializeDrmManager
{
    DRMOperationError errorHandler = ^(NSUInteger major, NSUInteger minor, NSError* nsErr) {
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        PlayerPlatformDrmFailureEventData *eventData = [[PlayerPlatformDrmFailureEventData alloc] init];
        eventData.major = [NSNumber numberWithInteger:major];
        eventData.minor = [NSNumber numberWithInteger:minor];
        eventData.error = nsErr;
        
        [notificationCenter postNotificationName:OFFLINE_DRM_FAILURE
                                          object:self
                                        userInfo:[eventData toDictionary]];
    };
    
    DRMOperationComplete completeHandler = ^(){
        //NSLog(@"Drm Initialization Complete");
    };
    
    [[DRMManager sharedManager] initialize:errorHandler complete:completeHandler];
}
-(void)setAssets:(NSArray *)assets withWorkflow:(DRMWorkFlowType)workFlow isOffline:(bool)offline
{
    _drmWorkFlowType = workFlow;
    PlayerPlatformDrmFailureEventData *eventData;
    if(offline)
    {
        switch (workFlow) {
            case PASSTHROUGH:
                _offlineWorkflow = [[PTOLWorkflow alloc] init];
                for (Asset *asset in assets) {
                    [_offlineWorkflow attachAsset:asset];
                }
                break;
            default:
                eventData = [[PlayerPlatformDrmFailureEventData alloc] init];
                eventData.major = [NSNumber numberWithInteger:8000];
                eventData.minor = [NSNumber numberWithInteger:2];
                
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:DRM_FAILURE
                                                  object:self
                                                userInfo:[eventData toDictionary]];
                break;
        }
    }
    else
    {
        switch (workFlow) {
            case PASSTHROUGH:
                _liveWorkflow = [[PTWorkflow alloc] init];
                for (Asset *asset in assets) {
                    [_liveWorkflow attachAsset:asset];
                }
                break;
            default:
                eventData = [[PlayerPlatformDrmFailureEventData alloc] init];
                eventData.major = [NSNumber numberWithInteger:8000];
                eventData.minor = [NSNumber numberWithInteger:3];
                
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:DRM_FAILURE
                                                  object:self
                                                userInfo:[eventData toDictionary]];
                break;
        }
    }
}

-(DRMProvider*)init{
    if (self = [super init]) {
    }
    return self;
}
@end
