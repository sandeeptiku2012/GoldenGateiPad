//
//  XMessageComposer.h
//  PlayerPlatform
//
//  Created by Cory Zachman on 10/10/12.
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
#import "AbstractXMessageBuilder.h"
#import "XMessage.h"
#import "XuaMessage.h"

@interface XMessageComposer : NSObject
@property AbstractXMessageBuilder *messageBuilder;
-(XMessage*)getMessage;
-(XuaMessage*)getFormattedMessage;
-(void)constructMessage;
@end
