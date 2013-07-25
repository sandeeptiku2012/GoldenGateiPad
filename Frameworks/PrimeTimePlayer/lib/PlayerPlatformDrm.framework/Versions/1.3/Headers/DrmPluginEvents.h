//
//  DrmPluginEvents.h
//  ios_drm
//
//  Created by Cory Zachman on 1/18/13.
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

@interface DrmPluginEvents : NSObject
extern NSString* const CIMA_COMPLETE;
extern NSString* const META_COMPLETE;
extern NSString* const PROVISION_COMPLETE;
extern NSString* const DEPROVISION_COMPLETE;
extern NSString* const INTERNAL_ERROR;
extern NSString* const SERVER_SECURITY_ERROR;
extern NSString* const SESSION_CREATED;
extern NSString* const SESSION_RENEWED;
extern NSString* const SESSION_PREFETCHED;
extern NSString* const UNPROVISIONED_ERROR;


@end
