//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "NavAction.h"

/*!
 @abstract
 A ViewAction is a NavAction that can hold FilterActions
 */
@interface ViewAction : NavAction

@property (strong, readonly, nonatomic) NSArray *filterActions;

@end