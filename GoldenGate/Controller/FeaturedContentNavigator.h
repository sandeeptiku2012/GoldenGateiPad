//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BlockDefinitions.h"

@class FeaturedContent;
@class GGBaseViewController;

/*!
 @abstract
 This class helps with handling navigation to a FeaturedContent object.
 A FeaturedObject can point to a Category, SubCategory, Channel or Video.
 This class does the correct thing given the FeaturedContent object and
 a GGBaseViewController
 */
@interface FeaturedContentNavigator : NSObject

+ (void)navigateToFeaturedContent:(FeaturedContent*)featuredContent
               fromViewController:(GGBaseViewController *)viewController
                completionHandler:(VoidHandler)onComplete;

@end