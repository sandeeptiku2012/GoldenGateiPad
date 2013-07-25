//
//  GenericTupleMessage.h
//  PlayerPlatformIOSAnalytics
//
//  Created by Cory Zachman on 2/18/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.
//

#import "AbstractXMessageBuilder.h"

@interface GenericTupleMessage : AbstractXMessageBuilder
-(GenericTupleMessage*)initWithTimestamp:(NSInteger)evtTimestamp
                                 withName:(NSString *)eventName
                                withValue:(NSDictionary *)eventValue
                                withAsset:(AbstractXuaAsset *)asset;
@end
