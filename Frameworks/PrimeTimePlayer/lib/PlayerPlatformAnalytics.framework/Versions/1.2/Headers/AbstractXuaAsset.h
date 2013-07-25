//
//  AbstractXuaAsset.h
//  PlayerPlatform
//
//  Created by Cory Zachman on 10/17/12.
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
#import "XuaAssetIds.h"

@interface AbstractXuaAsset : NSObject
@property XuaAssetIds *assetIds;
@property NSString *assetType;
-(NSString*)toJson;
@end
