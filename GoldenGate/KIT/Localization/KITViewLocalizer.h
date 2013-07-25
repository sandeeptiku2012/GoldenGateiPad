//
//  Created by Andreas Petrov on 5/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

#define kDefaultlocalizedTextSuffix @"LKey"

@class KITLocalizer;

@interface KITViewLocalizer : NSObject

- (id)initWithLocalizer:(KITLocalizer*)localizer;

- (void)localizeView:(UIView *)view;

/*!
 @abstract The text that a UI element with a text value should end with to be included in the localization process.
 The default value is LKey
 */
@property (strong, nonatomic) NSString *localizedTextSuffix;

@property (strong, nonatomic) KITLocalizer *localizer;

@end