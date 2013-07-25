//
//  SecurityToken.h
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
@interface SecurityToken : NSObject<NSCoding>
extern NSString* const CIMA_TOKEN;
extern NSString* const META_TOKEN;
extern NSString* const XSCT_TOKEN;
extern NSString* const XACT_TOKEN;

@property NSString *token;
@property NSString *notOnOrAfter;
@property NSString *type;
-(bool)isValid;
-(SecurityToken*)initWithType:(NSString*)type withToken:(NSString*)token withNotOnOrAfter:(NSString*)notOnOrAfter;
@end
