//
//  KITLocalizationDataSource.h
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KITLanguage;

/*!
 @abstract this is the superclass used by the KITLocalizer to
 map a string key to a corresponding value string.
 Subclasses might implement different ways of getting this data.
 */
@interface KITLocalizationDataSource : NSObject

/*!
 @abstract Map from a key string to a value string.
 @discussion 
 Please re-implement in subclasses.
 */
-(NSString*)lookupStringForKey:(NSString*)key;

/*!
 @abstract Called automatically when a new language is set.
 @discussion Please re-implement in subclasses
 */
- (void)languageDidChange:(KITLanguage*)newLanguage;

/*!
 @abstract the current language this localization data source uses.
 @discussion setting this will trigger langageDidChange which must be re-implemented in subclasses
 to handle language change.
 */
@property (strong, nonatomic) KITLanguage *language;

@end
