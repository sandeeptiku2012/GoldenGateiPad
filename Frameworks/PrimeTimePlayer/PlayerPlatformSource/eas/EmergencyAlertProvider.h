//
//  EmergencyAlertProvider.h
// PlayerPlatform
//
//  Created by Bryan Pauk on 1/29/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>
#import "PlayerPlatformAPI.h"
#import "Asset.h"
#import "Alert.h"
#import "EmergencyAlertSettings.h"
#import <UIKit/UIKit.h>


@interface EmergencyAlertProvider : NSObject
+(id)sharedInstance;
-(void) configureAlertProvider:(NSString*) tokenToFipsUrl alertServiceUrl:(NSString*)alertServiceUrl token:(NSString*)token settings:(EmergencyAlertSettings*)settings;
-(void) setPlayerPlatform:(PlayerPlatformAPI*) playerPlatform;
-(void) deactivatePolling;
-(void) initPolling;
@end
