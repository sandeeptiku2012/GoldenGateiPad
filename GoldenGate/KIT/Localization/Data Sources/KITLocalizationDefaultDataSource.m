//
//  KITLocalizationDefaultDataSource.m
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizationDefaultDataSource.h"
#import "KITLanguage.h"

@implementation KITLocalizationDefaultDataSource

-(NSString*)lookupStringForKey:(NSString*)key
{
    NSString *localizedString = [self.language.bundle localizedStringForKey:key 
                                                                      value:nil 
                                                                      table:nil];
    return localizedString;
}

@end
