//
//  CimaService.h
//  ios_drm
//
//  Created by Cory Zachman on 1/17/13.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//

#import <Foundation/Foundation.h>
#import "ClientStateProtocol.h"

@interface CimaService : NSObject
/**
 * Initializes a new Cima Service with username, password, and clientState
 *
 */
-(CimaService*) initWithUsername:(NSString*)username withPassword:(NSString*)password withClientState:(NSObject<ClientStateProtocol>*) clientState;

-(void)setUsernamePassword:(NSString*)username password:(NSString*)password;

/**
 * Retrieves a new cima token and stores this token in the ClientStateProtocol
 * Upon successful completetion, this method will dispatch a CIMA_COMPLETE event.
 * If an error has occured, it will dispatch a INTERNAL_ERROR, SERVER_SECURITY_ERROR, or UNPROVISIONED_ERROR.
 *      INTERNAL_ERROR are unrecoverable, and SERVER_SECURITY_ERROR are error responses from the
 *      Comcast Security Servers
 */
-(void)create;

/**
 * DO NOT CALL THIS METHOD. SECURITY TEAM HAS NOT IMPLEMENTED THIS SERVICE.
 *
 * Renews the cima token that is stored within the ClientStateProtocol.
 * Upon successful completetion, this method will dispatch a CIMA_COMPLETE event.
 * If an error has occured, it will dispatch a INTERNAL_ERROR, SERVER_SECURITY_ERROR, or UNPROVISIONED_ERROR.
 *      INTERNAL_ERROR are unrecoverable, and SERVER_SECURITY_ERROR are error responses from the
 *      Comcast Security Servers
 */
-(void)renew;
@end
