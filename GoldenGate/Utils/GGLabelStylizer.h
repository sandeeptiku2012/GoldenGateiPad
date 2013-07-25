//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "KITLabelStylizer.h"

/*!
 @abstract 
 A label stylizer set up to use the specific custom font for this project.
 */
@interface GGLabelStylizer : KITLabelStylizer

+ (GGLabelStylizer*)sharedInstance;

/*!
 @abstract
 Returns a text property dictionary with a given font size.
 Used for text on back buttons, navbars and navbaritems.
 */
+ (NSDictionary*)textPropertyDictWithFontSize:(CGFloat)fontSize;


/*!
 @abstract
 Returns the font size to be used in controls that look like GGBarButton
 */
+ (CGFloat)barButtonTitleFontSize;

@end