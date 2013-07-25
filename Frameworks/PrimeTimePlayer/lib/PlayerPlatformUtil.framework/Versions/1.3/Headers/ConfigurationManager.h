//
//  ConfigurationManager.h
//  PlayerPlatformUtil
//
//  Created by Cory Zachman on 3/12/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigurationManager : NSObject
//Events
extern NSString* const CONFIG_COMPLETE;
extern NSString* const CONFIG_FAILURE;

//Tags
extern NSString* const DRM_TAG;
extern NSString* const APP_TAG;
extern NSString* const EAS_TAG;
extern NSString* const ANALYTICS_TAG;
extern NSString* const AUDITUDE_TAG;

//DrmSettings
extern NSString* const CIMA_END_POINT;
extern NSString* const METADATA_END_POINT;
extern NSString* const PRODUCT_TYPE;
extern NSString* const MAX_OPERATION_TIME;

//EasSettings
extern NSString* const ZIP_TO_FIPS_ENDPOINT;
extern NSString* const ALERT_SERVICE_ENDPOINT;
extern NSString* const EAS_UPDATE_INTERVAL;
extern NSString* const EAS_ALERT_REPEAT;
extern NSString* const EAS_ALERT_FONT;
extern NSString* const EAS_ALERT_FONT_SIZE;

//AnalyticsSettings
extern NSString* const ANALYTICS_ENDPOINT;
extern NSString* const ANALYTICS_PROTOCOL;
extern NSString* const ANALYTICS_DEVICE_TYPE;
extern NSString* const MAX_BATCH_SIZE;
extern NSString* const MAX_QUEUE_SIZE;
extern NSString* const BATCH_INTERVAL;

//AppSettings
extern NSString* const HEARTBEAT_INTERVAL;
extern NSString* const AUTOPLAY;
extern NSString* const MINIMUM_BITRATE;
extern NSString* const MAXIMUM_BITRATE;
extern NSString* const INITIAL_BITRATE;

//AuditudeSettings
extern NSString* const DOMAIN_ID;
extern NSString* const ZONE_ID;

-(ConfigurationManager*)init;
+(id)sharedInstance;
-(void)loadConfigurationFromXmlString:(NSString*)xmlString;
-(void)loadConfigurationFromUrl:(NSString*)configurationUrl;
-(NSString*)getConfigValue:(NSString*)configString;
-(bool)isReady;
@end

