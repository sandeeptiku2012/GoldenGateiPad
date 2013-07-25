//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ViewAction.h"

@class ContentCategory;

@interface CategoryAction : ViewAction

- (id)initWithCategory:(ContentCategory *)category;

@property (strong, readonly, nonatomic) NSArray *subActions;

@property (strong, readonly, nonatomic) ContentCategory *category;


/*!
 @abstract
 Populates the subActions array if it's not already populated.
 @note
 May invoke a synchronous HTTP request. Use only on background threads.
 */
- (void)loadSubActionsIfNeeded;

@end