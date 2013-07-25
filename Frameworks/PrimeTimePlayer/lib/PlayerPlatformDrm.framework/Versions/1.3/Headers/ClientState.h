//
//  ClientState.h
//  ios_drm
//
//  Created by Cory Zachman on 1/17/13.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//

#import <UIKit/UIKit.h>
#import "ClientStateProtocol.h"
#import "SecurityToken.h"

/**
 * Default inmemory client state object used for testing. 
 * Please create your own that can persist to disk
 **/
@interface ClientState : NSObject<ClientStateProtocol>
@end
