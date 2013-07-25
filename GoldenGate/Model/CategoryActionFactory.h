//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class CategoryAction;
@class ContentCategory;

@interface CategoryActionFactory : NSObject

+ (CategoryActionFactory *)sharedInstance;

/*!
 @abstract
 Finds an existing or creates a new CategoryAction for a given category ID
 @note
 This method does some synchronous HTTP calls. And thus shouldn't be run on the main thread.
 */
- (CategoryAction *)categoryActionForCategoryID:(NSNumber *)identifier;

/*!
 @abstract 
 Finds an existing or creates a new CategoryAction for a given category.
 @note
 This method does NOT recursively traverse all parents of the category like
 categoryActionForCategoryID: does.
 */
- (CategoryAction *)categoryActionForCategory:(ContentCategory*)category;

- (NSArray *)subcategoryActionsForCategory:(ContentCategory *)category;

@end