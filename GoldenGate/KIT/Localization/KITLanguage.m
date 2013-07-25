//
//  KITLanguage.m
//  KIT
//
//  Created by Andreas Petrov on 4/30/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLanguage.h"

@interface KITLanguage() {
    BOOL bundleInitDone;
    NSString *_displayName;
}

@property (assign, readwrite, nonatomic) BOOL isSystemLanguage;

@end

@implementation KITLanguage

static KITLanguage *systemLanguage = nil;

#pragma mark - Init

- (id)initWithIsoCode:(NSString *)anIsoCode
{
    if ((self = [super init])) 
    {
        _isoCode = anIsoCode;
        bundleInitDone = NO;
    }
    
    return self;
}

- (void)initBundleForLanguage
{
    if (bundleInitDone) 
    {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:self.isoCode ofType:@"lproj"];
    if (path != nil) 
    {
        _bundle = [NSBundle bundleWithPath:path];
    }
    else if (self.isSystemLanguage) 
    {
        _bundle = [NSBundle mainBundle];
    }
    
    // Prevent this code from running twice.
    bundleInitDone = YES;
}


#pragma mark - Public methods

+ (KITLanguage*)systemLanguage
{
    if (systemLanguage == nil) 
    {
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        if (preferredLanguages) 
        {
            NSString *currentSystemLanguage = [preferredLanguages objectAtIndex:0];
            systemLanguage = [[KITLanguage alloc]initWithIsoCode:currentSystemLanguage];
        }
    }
    
    return systemLanguage;
}

#pragma mark - Properties

- (BOOL)isSystemLanguage
{
    KITLanguage * lang = [KITLanguage systemLanguage];
    _isSystemLanguage = [self.isoCode isEqualToString:lang.isoCode];
    
    return _isSystemLanguage;
}

- (NSString*)displayName
{
    if (_displayName == nil)
    {
        _displayName = [[NSLocale currentLocale]displayNameForKey:NSLocaleIdentifier value:self.isoCode];
    }
    
    return _displayName;
}

- (NSBundle*)bundle 
{
    if (_bundle == nil)
    {
        [self initBundleForLanguage];
    }
    
    return _bundle;
}

@end
