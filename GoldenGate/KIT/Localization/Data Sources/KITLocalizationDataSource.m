//
//  KITLocalizationDataSource.m
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizationDataSource.h"

@implementation KITLocalizationDataSource

@synthesize language;

-(NSString*)lookupStringForKey:(NSString*)key
{
    return nil;
}

- (void)languageDidChange:(KITLanguage*)newLanguage
{
    // Default impl. does nothing. Please override when needed!
}

#pragma mark - Properties

- (void)setLanguage:(KITLanguage *)newLang
{
    if (language != newLang) 
    {
        language = newLang;
        [self languageDidChange:newLang];
    }
}

@end
