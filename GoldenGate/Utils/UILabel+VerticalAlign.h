//
//  UILabel+Extension.h
//  DnBNOR
//
//  Created by Andreas Petrov on 10/18/11.
//  Copyright 2011 Reaktor Magma AS. All rights reserved.
//  Source http://stackoverflow.com/questions/1054558/how-do-i-vertically-align-text-within-a-uilabel/3676733#3676733
//

#import <Foundation/Foundation.h>

/*!
 Labels can only align their text horizontally. This adds capability to align
 vertically.
*/
@interface UILabel (VerticalAlign)

- (void)alignTop;

- (void)alignBottom;

@end


