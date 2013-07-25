//
//  AbstractResponseDelegate.h
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
#import "ClientStateProtocol.h"

@interface AbstractResponseDelegate : NSObject<NSURLConnectionDelegate>
@property NSMutableData *responseData;
@property NSInteger majorCode;
@property NSInteger httpCode;
@property NSInteger status;
@property NSString *notOnOrAfter;
@property NSString *token;
@property NSString *messageId;
@property bool isParsed;
@property NSObject<ClientStateProtocol> *clientState;
@property NSString *majorDesc;

-(void)parseResponse;
@end
