//
//  ClientSessionRequest.h
//  ios_drm
//
//  Created by Cory Zachman on 3/31/13.
//  Copyright (c) 2013 Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <drmNativeInterface/DRMInterface.h>
#import "MetadataResponseDelegate.h"
#import "MetadataRequest.h"

@interface ClientSessionRequest : NSObject
-(ClientSessionRequest*)initWithClientState:(NSObject<ClientStateProtocol>*)clientState drmManager:(DRMManager*)drmManager;
-(ClientSessionRequest*)initWithClientState:(NSObject<ClientStateProtocol>*)clientState drmManager:(DRMManager*)drmManager withMetadataRequest:(MetadataRequest*)request delegate:(MetadataResponseDelegate*)delegate;
-(void)clientSession;
-(void)provision:(NSString*)accountToken;
-(void)deprovision;
@end
