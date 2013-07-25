//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NavAction.h"


@interface FilterAction : NavAction

@property (weak, nonatomic) Class viewControllerClass;

- (id)initWithName:(NSString *)name viewControllerClass:(Class)viewControllerClass;

/*!
 @abstract
 YES if view controllers spawned from this FilterAction are cachable.
 Default is YES.
 */
@property (assign, nonatomic) BOOL cachable;

@end