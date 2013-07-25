//
//  KITLocalizationDefaultDataSource.h
//  KIT
//
//  Created by Andreas Petrov on 4/29/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITLocalizationDataSource.h"

@interface KITLocalizationDefaultDataSource : KITLocalizationDataSource

/*!
 @abstract Map from a key string to a value string from the bundle corresponding to self.language.bundle
 @discussion 
 */
-(NSString*)lookupStringForKey:(NSString*)key;

@end
