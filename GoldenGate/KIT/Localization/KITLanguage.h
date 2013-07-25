//
//  KITLanguage.h
//  KIT
//
//  Created by Andreas Petrov on 4/30/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract This class wraps information related to languages.
 */
@interface KITLanguage : NSObject

+ (KITLanguage*)systemLanguage;

- (id)initWithIsoCode:(NSString*)isoCode;

/*!
 @abstract defines the iso code for this language.
 */
@property (strong, readonly, nonatomic) NSString *isoCode;

/*!
 @abstract returns a UI-friendly display name for this language.
 */
@property (strong, readonly, nonatomic) NSString *displayName;

/*!
 @abstract returns YES if this language is the current device language.
 */
@property (assign, readonly, nonatomic) BOOL isSystemLanguage;

/*!
 @abstract Returns the bundle for this language.
 Returns nil if there isn´t one.
 @discussion 
 Not read only because of unit tests needing to set this manually.
 You should not usually change this manually.
 */
@property (strong, nonatomic) NSBundle *bundle;

@end
