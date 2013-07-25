//
//  Asset.h
// PlayerPlatform
//
//  Created by Rustam Khashimkhodjaev on 9/9/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>

extern NSString* const ASSET_ID;
extern NSString* const PROVIDER_ID;
extern NSString* const STATION_ID;
extern NSString* const RELEASE_PID;
extern NSString* const LICENSE_ID;
extern NSString* const RELEASE_ID;
extern NSString* const MEDIA_ID;
extern NSString* const TP_ID;
extern NSString* const DRM_KEY;


@interface Asset : NSObject
@property(nonatomic, retain)NSString* manifestUrl;
@property(nonatomic, retain)NSMutableDictionary* contentOptions;
@property(nonatomic, retain)NSString* assetId;
@property(nonatomic, retain)NSString* providerId;
@property(nonatomic, retain)NSString* licenseId;
@property(nonatomic, retain)NSString* releaseId;
@property(nonatomic, retain)NSString* mediaId;
@property(nonatomic, retain)NSString* recordingId;
@property(nonatomic, retain)NSString* tpId;
@property(nonatomic, retain)NSString* drmKey;
-(Asset *)initWithContentOptions:(NSMutableDictionary*) contentOptions;

@end

