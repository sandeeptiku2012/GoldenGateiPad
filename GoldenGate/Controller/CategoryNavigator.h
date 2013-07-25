//
//  CategoryNavigator.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/25/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockDefinitions.h"

@class GGBaseViewController;

/*!
 @abstract
 This is a helper class that will use the NavActionExecutor to navigate to a category 
 of the given ID.
 */
@interface CategoryNavigator : NSObject

+ (void)navigateToCategoryWithId:(NSUInteger)identifier
              fromViewController:(GGBaseViewController *)viewController
               completionHandler:(VoidHandler)onComplete;

@end
