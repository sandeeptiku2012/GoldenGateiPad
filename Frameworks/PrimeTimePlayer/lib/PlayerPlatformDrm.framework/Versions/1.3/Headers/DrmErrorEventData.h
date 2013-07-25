//
//  InternalErrorEventData.h
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
#import "DrmPluginEventData.h"

@interface DrmErrorEventData : NSObject<DrmPluginEventData>

@property (nonatomic)NSNumber* majorCode;
@property (nonatomic)NSNumber* minorCode;
@property (nonatomic)NSString* messageId;
@property (nonatomic)NSString* majorDesc;
@property (nonatomic)NSString* minorDesc;
@property (nonatomic)NSString* type;

extern NSString* const KEY_FOR_MAJOR_CODE;
extern NSString* const KEY_FOR_MAJOR_DESC;
extern NSString* const KEY_FOR_MESSAGE_ID;
extern NSString* const KEY_FOR_MINOR_CODE;
extern NSString* const KEY_FOR_MINOR_DESC;
extern NSString* const KEY_FOR_TYPE;

@end
