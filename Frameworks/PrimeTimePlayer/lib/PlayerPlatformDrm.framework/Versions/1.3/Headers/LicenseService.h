//
//  LicenseService.h
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
#import "ClientStateProtocol.h"
@interface LicenseService : NSObject

/**
 * Initializes a new License Service with the client state provided
 * @param clientState - clientState object must not be null and implement the ClientStateProtocal.
 *                      all fetched keys will be stored in the clientState object
 *
 * @return LicenseService that can be used to create and renew Session Tokens.
 */
-(LicenseService*)initWithClientState:(NSObject<ClientStateProtocol>*)clientState;

/**
 * Retrieves a new Xsct Token and stores this token in the ClientStateProtocol
 * Upon successful completetion, this method will dispatch a SESSION_CREATED event.
 * If an error has occured, it will dispatch a INTERNAL_ERROR, SERVER_SECURITY_ERROR, or UNPROVISIONED_ERROR.
 *
 *      If you receive an UPROVISIONED_ERROR, use the provision to provision this device with
 *      an account token.
 *      INTERNAL_ERROR are unrecoverable, and SERVER_SECURITY_ERROR are error responses from the
 *      Comcast Security Servers
 */
-(void)clientSession;

/**
 * Retrieves a new Xsct Token and stores this token in the ClientStateProtocol
 * Upon successful completetion, this method will dispatch a PROVISION_COMPLETE event.
 * If an error has occured, it will dispatch a INTERNAL_ERROR, SERVER_SECURITY_ERROR, or UNPROVISIONED_ERROR.
 *
 *      If you receive an UPROVISIONED_ERROR, use the provision to provision this device with
 *      an account token.
 *      INTERNAL_ERROR are unrecoverable, and SERVER_SECURITY_ERROR are error responses from the
 *      Comcast Security Servers
 */
-(void)provision:(NSString*)token;

/**
 * DO NOT CALL THIS METHOD YET, IT IS NOT IMPLEMENTED
 *
 */
-(void)deprovision;
@end
