//
//  ClientSessionParser.h
//  ios_drm
//
//  Created by Cory Zachman on 4/1/13.
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
@interface ClientSessionParser : NSObject
@property NSString *messageId;
@property NSString *authnToken;
@property NSString *issueDate;
@property NSString *notOnOrAfter;
@property NSString *tokenDuration;
@property bool parsed;
-(ClientSessionParser*)initWithDrmLicense:(DRMLicense*)drmLicense;
@end
