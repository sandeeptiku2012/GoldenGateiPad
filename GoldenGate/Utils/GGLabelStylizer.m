//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "GGLabelStylizer.h"
#import "GGColor.h"

static GGLabelStylizer *gSharedInstance;

@implementation GGLabelStylizer
{

}

+ (GGLabelStylizer*)sharedInstance
{
    if (gSharedInstance == nil) {
        gSharedInstance = [[GGLabelStylizer alloc]initWithFontFamilyName:@"XFINITYSans"
                                                               regularPostfix:@"Med"
                                                                  boldPostfix:@"Bold"
                                                                 lightPostfix:@"Lgt"
                                                                italicPostfix:@""
                                                               spaceCharacter:@"-" ];
    }
    
    return gSharedInstance;
}
    
+ (NSDictionary*)textPropertyDictWithFontSize:(CGFloat)fontSize
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [GGColor veryLightGrayColor], UITextAttributeTextColor,
            [UIColor blackColor], UITextAttributeTextShadowColor,
            [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
            [[GGLabelStylizer sharedInstance]stylizedFontFromSystemFont:[UIFont boldSystemFontOfSize:fontSize]], UITextAttributeFont, nil];
}

+ (CGFloat)barButtonTitleFontSize
{
    return 13;
}

@end