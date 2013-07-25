//
//  ProvisionService.h
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

@interface ProvisionService : NSObject
-(ProvisionService*)initWithClientState:(NSObject<ClientStateProtocol>*) clientState;

/**
 * Retrieves a new cima token and stores this token in the ClientStateProtocol
 * Upon successful completetion, this method will dispatch a PROVISION_COMPLETE event.
 * If an error has occured, it will dispatch a INTERNAL_ERROR or SERVER_SECURITY_ERROR.
 *      INTERNAL_ERROR are unrecoverable, and SERVER_SECURITY_ERROR are error responses from the
 *      Comcast Security Servers
 */
-(void)provision:(NSString*)accountToken;
-(void)deprovision;
@end
