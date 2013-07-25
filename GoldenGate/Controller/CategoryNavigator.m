//
//  CategoryNavigator.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/25/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "CategoryNavigator.h"

#import "GGBaseViewController.h"
#import "CategoryAction.h"
#import "NavActionExecutor.h"
#import "CategoryActionFactory.h"


@implementation CategoryNavigator

+ (void)navigateToCategoryWithId:(NSUInteger)identifier
              fromViewController:(GGBaseViewController *)viewController
               completionHandler:(VoidHandler)onComplete
{
    NSAssert([viewController isKindOfClass:[GGBaseViewController class]], @"viewController must be of type GGBaseViewController");
    
    [viewController.viewControllerOperationQueue addOperationWithBlock:^
    {
        CategoryAction *actionToExecute = [[CategoryActionFactory sharedInstance]categoryActionForCategoryID:@(identifier)];
        [actionToExecute loadSubActionsIfNeeded];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^
        {
            [NavActionExecutor executeNavAction:actionToExecute fromViewController:viewController];
            if (onComplete)
            {
                onComplete();
            }
        }];
    }];
}

@end
