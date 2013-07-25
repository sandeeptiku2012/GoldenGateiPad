//
//  DRMProvider.h
// PlayerPlatform
//
//  Created by Cory Zachman on 10/5/12.
//
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation.



#import <Foundation/Foundation.h>
#import <PlayerPlatformDrm/DrmFramework.h>
#import "PlayerPlatformAPI.h"
#import "DRMWorkflow.h"
#import "DRMWorkFlowType.h"

@interface DRMProvider : NSObject
@property DRMWorkflow *offlineWorkflow;
@property DRMWorkflow *liveWorkflow;
+(id)sharedInstance;
-(void)setAssets:(NSArray*) assets
    withWorkflow:(DRMWorkFlowType) workFlow isOffline:(bool)offline;
-(void)initializeDrmManager;
@end
