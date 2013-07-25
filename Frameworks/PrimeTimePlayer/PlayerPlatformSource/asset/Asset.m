//
//  Asset.m
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "Asset.h"

@implementation Asset
NSString* const ASSET_ID = @"assetId";
NSString* const PROVIDER_ID = @"providerId";
NSString* const STATION_ID = @"stationId";
NSString* const RECORDING_ID = @"recordingID";
NSString* const LICENSE_ID = @"licenseID";
NSString* const RELEASE_ID = @"releaseID";
NSString* const MEDIA_ID = @"mediaID";
NSString* const TP_ID = @"tPID";
NSString* const DRM_KEY = @"drmKey";
-(id)init
{
    self = [super init];
    if (self) {
        self.contentOptions = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(Asset *)initWithContentOptions:(NSMutableDictionary*) contentOptions
{
    self.contentOptions = contentOptions;
    
    if([_contentOptions objectForKey:ASSET_ID] != NULL )
    {
        _assetId = [_contentOptions objectForKey:ASSET_ID];
    }
    
    if([_contentOptions objectForKey:PROVIDER_ID] != NULL )
    {
        _providerId = [_contentOptions objectForKey:PROVIDER_ID];
    }
    
    if([_contentOptions objectForKey:RECORDING_ID] != NULL )
    {
        _recordingId = [_contentOptions objectForKey:RECORDING_ID];
    }
    
    if([_contentOptions objectForKey:LICENSE_ID] != NULL )
    {
        _licenseId = [_contentOptions objectForKey:LICENSE_ID];
    }
    
    if([_contentOptions objectForKey:RELEASE_ID] != NULL )
    {
        _releaseId = [_contentOptions objectForKey:RELEASE_ID];
    }
    
    if([_contentOptions objectForKey:MEDIA_ID] != NULL )
    {
        _mediaId = [_contentOptions objectForKey:MEDIA_ID];
    }
    
    if([_contentOptions objectForKey:TP_ID] != NULL )
    {
        _tpId = [_contentOptions objectForKey:TP_ID];
    }
    
    if([_contentOptions objectForKey:DRM_KEY] != NULL )
    {
        _drmKey = [_contentOptions objectForKey:DRM_KEY];
    }
    
    
    return self;
}

@end

