//
//  KITLabelStylizer.m
//  KIT
//
//  Created by Andreas Petrov on 12/12/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//

#import "KITLabelStylizer.h"

@interface FontStyle : NSObject

enum FontWeight
{
    FontStyleFontWeightLight,
    FontStyleFontWeightRegular,
    FontStyleFontWeightBold
};

@property enum FontWeight weight;
@property BOOL italic;

- (id)initWithFont:(UIFont*)font;

@end

@implementation FontStyle

@synthesize weight;
@synthesize italic;

- (void)determineItalic:(UIFont*)font
{
    NSRange italicFound = [font.fontName rangeOfString:@"oblique" options:NSCaseInsensitiveSearch];
    self.italic =  italicFound.location != NSNotFound;
}

- (void)determineWeight:(UIFont*)font
{
    NSRange lightFound = [font.fontName rangeOfString:@"light" options:NSCaseInsensitiveSearch];
    self.weight = lightFound.location != NSNotFound ? FontStyleFontWeightLight : FontStyleFontWeightRegular;
    
    if (lightFound.location == NSNotFound) 
    {
        NSRange boldFound = [font.fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch];
        self.weight = boldFound.location != NSNotFound ? FontStyleFontWeightBold : FontStyleFontWeightRegular;
    }
}

// Only works reliably with system font
- (id)initWithFont:(UIFont*)font
{
    if ((self = [super init])) 
    {
        [self determineItalic:font];
        [self determineWeight:font];
    }
    
    return self;
}

@end

@interface KITLabelStylizer ()

@property (strong, nonatomic) NSString *fontFamilyName;
@property (strong, nonatomic) NSString *regularPostfix;
@property (strong, nonatomic) NSString *boldPostfix;
@property (strong, nonatomic) NSString *lightPostfix;
@property (strong, nonatomic) NSString *italicPostfix;
@property (strong, nonatomic) NSString *spaceCharacter;

@property (strong, nonatomic) NSMutableDictionary *translatedFontNames;

@end

@implementation KITLabelStylizer

@synthesize labelsToStylize;
@synthesize fontFamilyName;
@synthesize boldPostfix;
@synthesize lightPostfix;
@synthesize italicPostfix;
@synthesize regularPostfix;
@synthesize translatedFontNames;
@synthesize spaceCharacter;

- (id)initWithFontFamilyName:(NSString *)aFontFamilyName
              regularPostfix:(NSString *)aRegularPostfix 
                 boldPostfix:(NSString *)aBoldPostfix 
                lightPostfix:(NSString *)aLightPostfix 
               italicPostfix:(NSString *)anItalicPostfix 
              spaceCharacter:(NSString *)aSpaceCharacter
{
    if ((self = [super init]))
    {
        fontFamilyName = aFontFamilyName;
        boldPostfix = aBoldPostfix;
        lightPostfix = aLightPostfix;
        italicPostfix = anItalicPostfix;
        regularPostfix = aRegularPostfix;
        spaceCharacter = aSpaceCharacter;
        translatedFontNames = [[NSMutableDictionary alloc]init];
    }

    return self;
}

- (NSString *)determineFontNameFromSystemFont:(UIFont *)font
{
    FontStyle* styleForFont =  [[FontStyle alloc]initWithFont:font];

    NSString *weightPostfixString = @"";

    switch (styleForFont.weight) {
        case FontStyleFontWeightRegular:
            weightPostfixString = regularPostfix;
            break;
        case FontStyleFontWeightBold:
            weightPostfixString = boldPostfix;
            break;
        case FontStyleFontWeightLight:
            weightPostfixString = lightPostfix;
            break;
        default:
            break;
    }

    NSString *italicPostfixString = styleForFont.italic ? italicPostfix : @"";

    NSString *completePostfix = @"";
    if (weightPostfixString.length > 0)
    {
        completePostfix = [NSString stringWithFormat:@"%@%@",spaceCharacter,weightPostfixString];
    }
    
    if (italicPostfixString.length > 0) 
    {
        completePostfix = [NSString stringWithFormat:@"%@%@%@", completePostfix, spaceCharacter, italicPostfixString];
    }
    
    NSString *newFontName = [NSString stringWithFormat:@"%@%@",fontFamilyName, completePostfix];

    return newFontName;
}

- (UIFont *)stylizedFontFromSystemFont:(UIFont *)systemFont
{
    NSString * newFontName = [translatedFontNames valueForKey:systemFont.fontName];
    if (newFontName == nil)
    {
        newFontName = [self determineFontNameFromSystemFont:systemFont];
        [translatedFontNames setValue:newFontName forKey:systemFont.fontName];
    }
    
    return [UIFont fontWithName:newFontName size:systemFont.pointSize];
}

- (void)stylize:(UILabel *)label
{
    UIFont* f = [self stylizedFontFromSystemFont:label.font];
    label.font = f;
}

- (void)stylizeTextField:(UITextField *)textField 
{
    textField.font = [self stylizedFontFromSystemFont:textField.font];
}

- (void)stylizeTextView:(UITextView *)textView
{
    textView.font = [self stylizedFontFromSystemFont:textView.font];
}

- (void)stylizeButton:(UIButton *)button
{
    button.titleLabel.font = [self stylizedFontFromSystemFont:button.titleLabel.font];
}



@end
