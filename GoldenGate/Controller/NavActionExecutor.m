//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "NavActionExecutor.h"
#import "NavAction.h"
#import "BaseNavViewController.h"
#import "ViewAction.h"
#import "FilterAction.h"
#import "LogoutAction.h"

#define kMaxCachedViewControllers 6

@interface NavActionExecutor()

@end

static NSString *gNameOfLastUsedFilter;
static NSCache *gViewControllerCache;

@implementation NavActionExecutor
{

}

+ (void)initialize
{
    if (gViewControllerCache == nil)
    {
        gViewControllerCache = [NSCache new];
        gViewControllerCache.countLimit = kMaxCachedViewControllers;
    }
}

+ (void)clearViewControllerCache
{
    [gViewControllerCache removeAllObjects];
}

+ (void)handleLogoutActionWithViewController:(UIViewController *)viewController
{
    [self clearViewControllerCache];
    gNameOfLastUsedFilter = nil;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)executeNavAction:(NavAction *)action fromViewController:(UIViewController *)viewController
{
    if (!action)
    {
        return;
    }
    
    if ([action isKindOfClass:[LogoutAction class]])
    {
        [self handleLogoutActionWithViewController:viewController];
        return;
    }
    
    FilterAction *filterToPresent = [self filterFromAction:action];

    UINavigationController *navControllerToUse = viewController.navigationController;
    BOOL isRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController == navControllerToUse;
    if (isRootViewController || navControllerToUse == nil)
    {
        // Create an empty VC for root since iOS doesn't allow replacing the root view controller of a UINavigationController
        BaseNavViewController *emptyRootVC = [[BaseNavViewController alloc] init];
        navControllerToUse = [[UINavigationController alloc] initWithRootViewController:emptyRootVC];
    }

    [self presentFilterAction:filterToPresent navigationController:navControllerToUse];

    if (isRootViewController)
    {
        [viewController presentViewController:navControllerToUse animated:YES completion:nil];
    }
}

+ (FilterAction *)filterFromAction:(NavAction *)action
{
    FilterAction *filterAction = nil;
    if ([action isKindOfClass:[ViewAction class]])
    {
        ViewAction *viewActionToPresent = (ViewAction *) action;
        NSAssert(viewActionToPresent.filterActions.count > 0, @"Filter actions are needed to present a ViewAction");
        
        // Try to use the same filter as last used.
        if (gNameOfLastUsedFilter != nil)
        {
            for (FilterAction * filter in viewActionToPresent.filterActions)
            {
                if ([gNameOfLastUsedFilter isEqualToString:filter.name])
                {
                    filterAction = filter;
                }
            }
        }
    
        if (!filterAction)
        {
            // If we aren't navigating explicitly to a filter, choose the first
            filterAction = [viewActionToPresent.filterActions objectAtIndex:0];
        }
    }
    else if ([action isKindOfClass:[FilterAction class]])
    {
        filterAction = (FilterAction *) action;
    }
    
    gNameOfLastUsedFilter = filterAction.name;

    return filterAction;
}

+ (void)presentFilterAction:(FilterAction *)filterAction navigationController:(UINavigationController *)navController
{
    NSAssert(filterAction != nil && [filterAction isKindOfClass:[FilterAction class]], @"Method called without a valid FilterAction");

    // Build our wanted view action stack from the incoming filter action.
    NSArray *wantedViewActionStack  = [self createViewActionStackFromFilterAction:filterAction];

    // Build a view action stack based on what already exists in the UINavigationController
    NSArray *currentViewActionStack = [self createViewActionStackFromNavController:navController];

    NSInteger numberOfViewControllersToPop = 0;
    // Based on the current and wanted stack create a stack of actions that we want to push
    NSArray *viewActionsToPush = [self viewActionsToPush:wantedViewActionStack
                                  currentViewActionStack:currentViewActionStack
                            numberOfViewControllersToPop:&numberOfViewControllersToPop];

     // Pop off any un-needed view controllers.
    NSInteger stackSizeDiff = viewActionsToPush.count - numberOfViewControllersToPop;
    BOOL shouldAnimatePop = viewActionsToPush.count == 0 && stackSizeDiff < 0; // Can't animate pop if any views are to be pushed after the popping.
    [self popViewControllers:navController numberOfViewControllersToPop:numberOfViewControllersToPop shouldAnimatePop:shouldAnimatePop];

    // Push back on some new ones!
    [self pushViewControllers:filterAction navController:navController viewActionsToPush:viewActionsToPush stackSizeDiff:stackSizeDiff];
}

+ (void)pushViewControllers:(FilterAction *)filterAction
              navController:(UINavigationController *)navController
          viewActionsToPush:(NSArray *)viewActionsToPush
              stackSizeDiff:(int)stackSizeDiff
{
    for (NSUInteger i = 0; i < viewActionsToPush.count; ++i)
    {
        BOOL lastIteration = i == viewActionsToPush.count - 1;
        BOOL shouldAnimatePush = lastIteration && stackSizeDiff > 0;

        ViewAction *viewAction = viewActionsToPush[i];

        FilterAction *filterActionToPush = lastIteration ? filterAction : [self filterFromAction:viewAction];

        Class classToPush = filterActionToPush.viewControllerClass;
        UIViewController *viewControllerToPush = filterActionToPush.cachable ? [gViewControllerCache objectForKey:filterActionToPush] : nil;
        
        if (viewControllerToPush == nil)
        {
            viewControllerToPush = [[classToPush alloc] initWithNavAction:filterActionToPush];
            // Cache view controllers so that they're kept even though we push and pop the same level.
            [gViewControllerCache setObject:viewControllerToPush forKey:filterActionToPush];
        }

        BOOL isFirstProperViewControllerOnNavigationStack = navController.viewControllers.count == 1;
        viewControllerToPush.navigationItem.hidesBackButton = isFirstProperViewControllerOnNavigationStack;
        
        [navController pushViewController:viewControllerToPush animated:shouldAnimatePush];
    }
}

+ (void)popViewControllers:(UINavigationController *)navController
        numberOfViewControllersToPop:(NSUInteger)numberOfViewControllersToPop
                    shouldAnimatePop:(BOOL)shouldAnimatePop
{
    for (NSUInteger i = 0; i < numberOfViewControllersToPop; ++i)
    {
        BOOL lastIteration = i == numberOfViewControllersToPop - 1;
        BOOL animatePop = lastIteration && shouldAnimatePop;
        [navController popViewControllerAnimated:animatePop];
    }
}

+ (NSArray *)viewActionsToPush:(NSArray *)wantedViewActionStack
        currentViewActionStack:(NSArray *)currentViewActionStack
  numberOfViewControllersToPop:(NSInteger *)numberOfViewControllersToPop
{
    NSAssert(wantedViewActionStack.count > 0,@"Should have entries in the wantedViewActionStack by now");

    NSMutableArray *viewActionsToPush = [NSMutableArray new];
    *numberOfViewControllersToPop = 0;
    NSUInteger maxCount = MAX(wantedViewActionStack.count, currentViewActionStack.count);
    for (NSUInteger i = 0; i < maxCount; ++i)
    {
        ViewAction *wantedViewAction    = i < wantedViewActionStack.count ? wantedViewActionStack[i] : nil;
        ViewAction *currentViewAction   = i < currentViewActionStack.count ? currentViewActionStack[i] : nil;

        if (![wantedViewAction isEqual:currentViewAction])
        {
            if (wantedViewAction)
            {
                // Any view action NOT common on the stack must be pushed onto the stack after any popping is done.
                [viewActionsToPush addObject:wantedViewAction];
            }
            
            if (currentViewAction)
            {
                *numberOfViewControllersToPop = *numberOfViewControllersToPop + 1;
            }
        }
    }

    BOOL justNeedToSwapFilter = *numberOfViewControllersToPop == 0 && viewActionsToPush.count == 0;
    if (justNeedToSwapFilter)
    {
        // If there is no change in the ViewAction stack we just need to pop one view controller
        // and push another to make sure we change the current filter.
        *numberOfViewControllersToPop = 1;
        [viewActionsToPush addObject:[wantedViewActionStack lastObject]];
    }


    return viewActionsToPush;
}

+ (NSArray *)createViewActionStackFromNavController:(UINavigationController *)controller
{
    NSMutableArray *viewActionStack = [NSMutableArray new];
    for (BaseNavViewController *viewController in controller.viewControllers)
    {
        NSAssert([viewController isKindOfClass:[BaseNavViewController class]], @"viewController must be of class BaseNavViewController");
        if (viewController.navAction) // The root view controller will never have a valid navAction
        {
            [viewActionStack addObject: viewController.navAction.parentAction];
        }
    }

    return viewActionStack;
}

// Traverses given filter upwards towards the root and
// adds all ViewActions in an array. The last element in this array is the
// ViewAction deepest in the hierarchy
+ (NSArray *)createViewActionStackFromFilterAction:(FilterAction *)action
{
    NSMutableArray *viewActionStack = [NSMutableArray new];

    ViewAction *viewAction = (ViewAction *) action.parentAction;
    NSAssert(viewAction != nil, @"The given filter action should have a parent.");
    [viewActionStack addObject:viewAction];

    while (viewAction.parentAction)
    {
        viewAction = (ViewAction *) viewAction.parentAction;
        [viewActionStack insertObject:viewAction atIndex:0];
    }

    return viewActionStack;
}

@end