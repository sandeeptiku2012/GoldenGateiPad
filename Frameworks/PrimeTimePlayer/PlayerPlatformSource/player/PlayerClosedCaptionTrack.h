//
//  PlayerClosedCaptionTrack.h
//  PlayerPlatform
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
#import "PTMediaSelectionOption.h"
@interface PlayerClosedCaptionTrack : NSObject
-(id)initWithPTMediaSelectionOption:(id)mediaSelectionOption;
-(PTMediaSelectionOption*)getMediaSelectionOption;
-(NSString*)getLanguage;
-(NSString*)getOptionId;
-(NSString*)getTitle;
-(BOOL)isSelected;
-(BOOL)isDefault;
@end
