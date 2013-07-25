//
//  PlayerPlatformAd.m
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

#import "VideoAd.h"

@implementation VideoAd
-(id)initWithAd:(PTAd*)ad
{
    self = [super init];
    if(self)
    {
        self.id = ad.id;
        self.duration = ad.primaryAsset.duration;
    }
    return self;
}
@end
