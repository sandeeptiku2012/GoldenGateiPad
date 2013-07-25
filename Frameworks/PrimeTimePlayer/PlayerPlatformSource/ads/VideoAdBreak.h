//
//  PlayerPlatformAdBreak.h
//  PlayerPlatform
//
//  Created by Cory Zachman on 4/25/13.
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
#import <CoreMedia/CoreMedia.h>
#import "PTAdBreak.h"
@interface VideoAdBreak : NSObject
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) PTAdBreak *adBreak;
@property (nonatomic, assign) CMTimeRange relativeRange;
@property (nonatomic, assign) CMTimeRange range;
@property BOOL hasBeenSeen;
-(id)initWithVideoAdBreak:(PTAdBreak*)adBreak;
@end
