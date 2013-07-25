//
//  KITLocalizer.m
//  KIT
//
//  Created by Andreas Petrov on 4/30/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizer.h"
#import "KITLocalizationDataSource.h"
#import "KITLocalizationDefaultDataSource.h"
#import "KITLanguage.h"

NSString *const KITLocalizerLanguageChangedNotification = @"KITLocalizerLanguageChangedNotification";

static KITLocalizer * instance;

@interface KITLocalizer()

@property (strong, nonatomic) KITLocalizationDataSource *fallbackDataSource;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation KITLocalizer

@synthesize customLocale;
@synthesize fallbackDataSource;
@synthesize mainDataSource;
@synthesize preferredLanguage;
@synthesize dateFormatter;

#pragma mark - Init

- (id)init
{
    if ((self = [super init])) 
    {
        [self resetLocalization];
    }
    
    return self;
}

#pragma mark - Public methods

+ (KITLocalizer*)sharedInstance
{
    if (instance == nil) 
    {
        instance = [[KITLocalizer alloc]init];
    }
    
    return instance;
}

- (NSString*)localizedStringForKey:(NSString*)key comment:(NSString*)comment
{
    NSString *string = [self.mainDataSource lookupStringForKey:key];
    BOOL useFallback = string == nil;
    if (useFallback) 
    {
        string = [self.fallbackDataSource lookupStringForKey:key];
    }
    
    return string;
}

- (NSString *)localizedStringForDate:(NSDate*)date withFormat:(NSString*)dateFormat
{
    if (dateFormatter == nil) 
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.preferredLanguage.isoCode];
    }
    
    dateFormatter.dateFormat = dateFormat;
    
    return [dateFormatter stringFromDate:date];
}

- (void)resetLocalization
{
    self.fallbackDataSource = [[KITLocalizationDefaultDataSource alloc]init];
    [self setDataSourceLanguage: [KITLanguage systemLanguage]];
}

#pragma mark - Helpers

- (void)setDataSourceLanguage:(KITLanguage*)lang
{
    self.mainDataSource.language = lang;
    self.fallbackDataSource.language = lang;
}

#pragma mark - Properties

- (void)setMainDataSource:(KITLocalizationDataSource *)dataSource
{
    mainDataSource = dataSource;
    self.mainDataSource.language = self.preferredLanguage;
}

- (void)setPreferredLanguage:(KITLanguage *)aPreferredLanguage
{
    BOOL languageChanged = aPreferredLanguage != preferredLanguage;

    preferredLanguage = aPreferredLanguage;
    [self setDataSourceLanguage:aPreferredLanguage];
    
    if (languageChanged) 
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:KITLocalizerLanguageChangedNotification object:nil];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:aPreferredLanguage.isoCode forKey:@"PreferredLanguage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
   
    
    // Delete current date formatter here so it can be recreated with the new language.
    self.dateFormatter = nil;
    customLocale = nil;
}

- (NSLocale*)customLocale
{
    if (customLocale == nil) 
    {
        customLocale = [[NSLocale alloc]initWithLocaleIdentifier:self.preferredLanguage.isoCode];
        
        // If preferredLanguage is not set customLocale will be still be nil.
        // If that is so, set customLocale to currentLocale
        if (customLocale == nil) 
        {
            customLocale = [NSLocale currentLocale];
        }
    }
    
    return customLocale;
}

- (KITLanguage*)preferredLanguage
{
    if (preferredLanguage == nil) 
    {
        NSString *isoCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"PreferredLanguage"];
        BOOL noLanguageSet = isoCode == nil;
        if (noLanguageSet) 
        {
            preferredLanguage = [KITLanguage systemLanguage];
        }
        else 
        {
            preferredLanguage = [[KITLanguage alloc]initWithIsoCode:isoCode];
        }
    }
    
    return preferredLanguage;
}

@end
