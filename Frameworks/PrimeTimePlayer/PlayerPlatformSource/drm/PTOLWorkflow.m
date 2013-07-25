//
//  PTOLWorkflow.m
// PlayerPlatform
//
//  Created by Cory Zachman on 1/2/13.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.

#import "PTOLWorkflow.h"
#import <drmNativeInterface/DRMInterface.h>
#import "PlayerPlatformVideoEvent.h"
#import "PlayerPlatformDrmFailureEventData.h"
#import "PlayerPlatformDrmCompleteEventData.h"
@interface PTOLWorkflow ()
{
    Asset *_asset;
    DRMManager *_drmManger;
    DRMMetadata *_drmMetadata;
    DRMSession *_drmSession;
    DRMPolicy *_drmPolicy;
}
@end

@implementation PTOLWorkflow
-(PTOLWorkflow*)init
{
    return [super init];
}

-(void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _asset = nil;
    _drmManger = nil;
    _drmMetadata = nil;
    _drmSession = nil;
    _drmPolicy = nil;
}

-(void)attachAsset:(Asset *)asset
{
    _asset = asset;
    if([_asset.manifestUrl rangeOfString:@"?faxs=1"].location == NSNotFound)
    {
        _asset.manifestUrl = [_asset.manifestUrl stringByAppendingString:@"?faxs=1"];
    }
    [self validate];
    
}

-(void)validate
{
    _drmManger = [DRMManager sharedManager];
    
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
    
    DRMLicenseAcquired acquiredHandler = ^(DRMLicense *license) {
       // NSLog(@"Offline DRM License Acquired - Start Date: %@, End Date: %@, Playback Start Date: %@, Playback End Date: %@,  Offline Start Date: %@, Offline End Date: %@", license.getLicenseStartDate, license.getLicenseEndDate,license.getPlaybackTimeWindow.getPlaybackStartDate,license.getPlaybackTimeWindow.getPlaybackEndDate, license.getOfflineStorageStartDate, license.getOfflineStorageEndDate);
        
        PlayerPlatformDrmCompleteEventData *eventData = [[PlayerPlatformDrmCompleteEventData alloc] init];
        eventData.startDate = license.getLicenseStartDate;
        eventData.endDate = license.getLicenseEndDate;
        eventData.assetUrl = _asset.manifestUrl;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:OFFLINE_DRM_COMPLETE
                                          object:self
                                        userInfo:[eventData toDictionary]];
        [self destroy];
    };
    
    DRMOperationComplete authenticationTokenSetComplete = ^()
    {
        [self acquireLicense:errorHandler acquiredHandler:acquiredHandler];
    };
    
    if([_asset.manifestUrl rangeOfString:@"?faxs=1"].location == NSNotFound)
    {
        return;
    }
    else
    {
        [_drmManger getUpdatedPlaylist:[NSURL URLWithString:_asset.manifestUrl]
                                 error:errorHandler
                               updated:^(NSURL * newPlaylist, DRMMetadata * newMetadata)
         {
             _drmMetadata = newMetadata;
             _drmPolicy = [[newMetadata getPolicies] objectAtIndex:0];

             if([_drmPolicy getAuthenticationMethod] == ANONYMOUS)
             {
                 if ([[_asset contentOptions] objectForKey:DRM_KEY] != nil) {
                     [self setAuthenticationToken:errorHandler onComplete:authenticationTokenSetComplete];
                 }
                 else
                 {
                     [self acquireLicense:errorHandler acquiredHandler:acquiredHandler];
                 }
             }
             else if([_drmPolicy getAuthenticationMethod] == USERNAME_AND_PASSWORD)
             {
                 [self setAuthenticationToken:errorHandler onComplete:authenticationTokenSetComplete];
             }
             else
             {
                 PlayerPlatformDrmFailureEventData *eventData = [[PlayerPlatformDrmFailureEventData alloc] init];
                 eventData.major = [NSNumber numberWithInteger:8000];
                 eventData.minor = [NSNumber numberWithInteger:1];
                 
                 NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                 [notificationCenter postNotificationName:OFFLINE_DRM_FAILURE
                                                   object:self
                                                 userInfo:[eventData toDictionary]];
             }
         }];
    }
}

-(void)acquireLicense:(DRMOperationError)errorHandler acquiredHandler:(DRMLicenseAcquired)acquiredHandler
{
    //NSLog(@"Attempting anonymous DRM authentication of %@ licenseId:%@ on server: %@",_asset.manifestUrl,[_drmMetadata getLicenseId],[_drmMetadata getServerUrl]);
    [_drmManger acquireLicense:_drmMetadata
                       setting:ALLOW_SERVER
                         error:errorHandler
                      acquired:acquiredHandler];
}

-(void)setAuthenticationToken:(DRMOperationError)errorHandler onComplete:(DRMOperationComplete)onComplete
{
    //NSLog(@"Attempting USER/PASS DRM authentication of %@ licenseId:%@ on server: %@",_asset.manifestUrl,[_drmMetadata getLicenseId],[_drmMetadata getServerUrl]);
    [_drmManger setAuthenticationToken:_drmMetadata
                  authenticationDomain:[_drmPolicy getAuthenticationDomain]
                                 token:[[[_asset contentOptions] objectForKey:DRM_KEY] dataUsingEncoding:NSUTF8StringEncoding]
                                 error:errorHandler
                              complete:onComplete];
}


@end
