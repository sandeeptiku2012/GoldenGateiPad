//
//  ClientStateProtocal.h
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
#import "SecurityToken.h"

@protocol ClientStateProtocol <NSObject>
@required
-(void)addSecurityToken:(SecurityToken*)securityToken;
-(SecurityToken*)retrieveSecurityToken:(NSString*)securityTokenType;
-(NSArray*)listSecurityTokenTypes;
-(void)deleteAllSecurityTokens;
-(void)deleteSecurityToken:(SecurityToken*)securityToken;
@end

enum SecurityTokenType {
    CimaSecurityToken = 1,
    XactSecurityToken = 2,
    XsctSecurityToken = 3,
    ProvisionToken = 4,
    MetadataToken = 5
};

