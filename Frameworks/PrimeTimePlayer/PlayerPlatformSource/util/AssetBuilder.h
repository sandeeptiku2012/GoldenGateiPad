//
//  AssetBuilder.h
// PlayerPlatform
//
//  Created by Cory Zachman on 11/29/12.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>
#import <PlayerPlatformAnalytics/PAIDAsset.h>
#import <PlayerPlatformAnalytics/MerlinAsset.h>
#import <PlayerPlatformAnalytics/AAEIDAsset.h>
#import <PlayerPlatformAnalytics/CRPIDAsset.h>
#import "Asset.h"

@interface AssetBuilder : NSObject
-(AbstractXuaAsset*)buildAsset:(Asset*)asset;

@end
