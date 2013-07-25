//
//  UIColor_GoldenGate.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @abstract 
 A centralized place for creating colors specific for the GoldenGate project.
 */

@interface GGColor : NSObject

+ (UIColor*)veryLightGrayColor;
+ (UIColor*)lightGrayColor;
+ (UIColor*)lightGoldColor;
+ (UIColor*)darkGoldColor;
+ (UIColor*)darkGrayColor;
+ (UIColor*)mediumGrayColor;

@end
