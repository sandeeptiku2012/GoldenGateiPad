//
//  KITLabelStylizer.h
//  KIT
//
//  Created by Andreas Petrov on 12/12/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KITLabelStylizer : NSObject

@property (strong, nonatomic) NSMutableArray *labelsToStylize;

- (id)initWithFontFamilyName:(NSString *)aFontFamilyName
              regularPostfix:(NSString *)aRegularPostfix 
                 boldPostfix:(NSString *)aBoldPostfix 
                lightPostfix:(NSString *)aLightPostfix 
               italicPostfix:(NSString *)anItalicPostfix 
              spaceCharacter:(NSString *)aSpaceCharacter;

- (void)stylize:(UILabel*)label;
- (void)stylizeTextField:(UITextField *)textField;
- (void)stylizeTextView:(UITextView *)textView;
- (void)stylizeButton:(UIButton *)button;

- (UIFont*)stylizedFontFromSystemFont:(UIFont*)systemFont;

@end
