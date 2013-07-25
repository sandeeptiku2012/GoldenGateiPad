//
//  EmergencyAlertSettings.h
// PlayerPlatform
//
//  Created by Bryan Pauk on 1/9/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EmergencyAlertSettings : NSObject
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) NSNumber *pollingInterval;
@property (nonatomic) NSNumber *alertRepeatCount;
@end
