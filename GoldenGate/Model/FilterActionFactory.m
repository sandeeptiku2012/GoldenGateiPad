//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "FilterActionFactory.h"
#import "ContentCategory.h"
#import "FilterAction.h"
#import "MainCategoryViewController.h"
#import "HomeViewController.h"
#import "SubCategoryViewController.h"
#import "NewInCategoryViewController.h"
#import "ViewAction.h"
#import "ChannelsAToZViewController.h"
#import "NewVideosForUserViewController.h"
#import "PopularInCategoryViewController.h"
#import "FavoritesViewController.h"
#import "CategoryAction.h"
#import "MyChannelsAction.h"
#import "FavoritesAction.h"
#import "RowsSubscriptionViewController.h"
#import "ChannelsSubscriptionViewController.h"
#import "ShowsSubscriptionsViewController.h"
#import "HomeViewController.h"
#import "SubscriptionsViewController.h"

@implementation FilterActionFactory
{

}

+ (NSArray *)createFilterActionsForViewAction:(ViewAction*)viewAction
{
    if ([viewAction isKindOfClass:[CategoryAction class]])
    {
        CategoryAction* action = (CategoryAction*)viewAction;
        return [FilterActionFactory createFilterActionsForCategory:action.category];
    }
    else if ([viewAction isKindOfClass:[MyChannelsAction class]])
    {
        return [FilterActionFactory createFilterActionsForMyChannels];
    }
    else if ([viewAction isKindOfClass:[FavoritesAction class]])
    {
        return [FilterActionFactory createFilterActionsForFavorites];
    }

    return nil;
}

+ (NSArray*)createFilterActionsForFavorites
{
    FilterAction *favorites   = [[FilterAction alloc] initWithName:NSLocalizedString(@"FavoritesLKey", @"") viewControllerClass:[FavoritesViewController class]];
    favorites.cachable = NO;
    return @[favorites];
}

+ (NSArray *)createFilterActionsForMyChannels
{

    //Satish: Filter actions created for Rows, Shows and Channels
    FilterAction *rowsAction   = [[FilterAction alloc] initWithName:NSLocalizedString(@"RowsLKey", @"")   viewControllerClass:[RowsSubscriptionViewController class]];
    rowsAction.cachable = NO;

    FilterAction *showsAction  = [[FilterAction alloc] initWithName:NSLocalizedString(@"ShowsLKey", @"")    viewControllerClass:[ShowsSubscriptionsViewController class]];
    showsAction.cachable = NO;
    
    FilterAction *channelsAction  = [[FilterAction alloc] initWithName:NSLocalizedString(@"ChannelsLKey", @"")    viewControllerClass:[ChannelsSubscriptionViewController class]];
    channelsAction.cachable = NO;
    
    return @[rowsAction, showsAction, channelsAction];
}

+ (NSArray *)createFilterActionsForCategory:(ContentCategory *)category
{
    Class featuredActionVCClass = category.categoryLevel == ContentCategoryLevelSub ? [SubCategoryViewController class] : [MainCategoryViewController class]; 
    FilterAction *featuredAction  = [[FilterAction alloc] initWithName:NSLocalizedString(@"StoreLKey", @"") viewControllerClass:featuredActionVCClass];
    FilterAction *homeAction       = [[FilterAction alloc] initWithName:NSLocalizedString(@"HomeLKey", @"") viewControllerClass:[HomeViewController class]];
    FilterAction *subscriptionsAction = [[FilterAction alloc] initWithName:NSLocalizedString(@"SubscriptionsLKey", @"") viewControllerClass:[SubscriptionsViewController class]];

    return @[featuredAction, homeAction, subscriptionsAction];
}

@end