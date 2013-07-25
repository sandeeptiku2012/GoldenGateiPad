//
//  KITLocalizer.h
//  KIT
//
//  Created by Andreas Petrov on 4/30/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef KITLocalizedString
#undef KITLocalizedString
#endif
#define KITLocalizedString(key, comment) \
[[KITLocalizer sharedInstance] localizedStringForKey:(key) comment:(comment)] 

#ifndef KITLocalizedDate
#define KITLocalizedDate(date, dateFormat) \
[[KITLocalizer sharedInstance] localizedStringForDate:(date) withFormat:(dateFormat)]
#endif

#ifndef KITLocalizationSystemCustomLocale
#define KITLocalizationSystemCustomLocale() \
[KITLocalizer sharedInstance].customLocale
#endif

#ifndef KITLocalizationSystemPreferredLanguage
#define KITLocalizationSystemPreferredLanguage() \
[KITLocalizer sharedInstance].preferredLanguage
#endif

extern NSString *const KITLocalizerLanguageChangedNotification;

@class KITLocalizationDataSource;
@class KITLanguage;

@interface KITLocalizer : NSObject

+ (KITLocalizer*)sharedInstance;

/*!
 @abstract Gets the localized string for a given key.
 Use the NSLocalizedString macro instead of this
 */
- (NSString*)localizedStringForKey:(NSString*)key comment:(NSString*)comment;

/*!
 @abstract The main data source to use for localizing strings with the KITLocalizer
 @discussion If mainDataSource is nil fallbackDataSource will be used. This fallback 
 data source will use the Localized.Strings files for preferredLanguate for localization.
 */
@property (strong, nonatomic) KITLocalizationDataSource *mainDataSource;


/*!
 Utility function for formatting a date given the locale defined in the prefferedLanguage property
 @param date the date to format
 @param format the format to format the given date in
 @@return a localized string representation of date with the given dateFormat
 */
- (NSString *)localizedStringForDate:(NSDate*)date withFormat:(NSString*)dateFormat;

/*!
 * resets localization system so it uses NSBundle mainBundle
 */
- (void) resetLocalization;

/*!
 Stores the user´s preferred language in NSUserDefaults.
 This is done to customize appearance on UI controls app-wide.
 @return preferred language or nil if user hasn´t specified one yet. 
 */
@property (strong, nonatomic) KITLanguage *preferredLanguage;


/*!
 @return NSLocale created with locale identifier equal to preferredLanguage
 */
@property (strong, readonly, nonatomic) NSLocale *customLocale;

@end
