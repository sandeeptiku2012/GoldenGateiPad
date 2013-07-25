//
//  Created by Andreas Petrov on 10/31/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "FeaturedContentNavigator.h"
#import "FeaturedContent.h"
#import "GGBaseViewController.h"
#import "EntityVideoPlaybackViewController.h"
#import "CategoryStore.h"
#import "VimondStore.h"
#import "ContentCategory.h"
#import "CategoryNavigator.h"
#import "EntityModalViewController.h"
#import "DisplayEntity.h"
#import "Channel.h"
#import "Show.h"
#import "BundleStore.h"
#import "Bundle.h"


@implementation FeaturedContentNavigator
{

}
+ (void)navigateToFeaturedContent:(FeaturedContent *)featuredContent
               fromViewController:(GGBaseViewController *)viewController
                completionHandler:(VoidHandler)onComplete
{
    [viewController runOnBackgroundThread:^
    {
        switch (featuredContent.contentType)
        {
            case FeaturedContentTypeCategory:
                [self handleFeaturedCategory:featuredContent withViewController:viewController];
                break;
            case FeaturedContentTypeEntity:
                [self handleFeaturedDispEntity:featuredContent withViewController:viewController];
                break;
            case FeaturedContentTypeAsset:
                [self handleFeaturedAsset:featuredContent withViewController:viewController];
                break;
            case FeaturedContentTypeBundle:
                [self handleFeaturedBundle:featuredContent withViewController:viewController];
                break;
            default:
                break;
        }

        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            if (onComplete)
            {
                onComplete();
            }
        }];
    }];
}

+ (void)handleFeaturedAsset:(FeaturedContent *)featuredContent
         withViewController:(GGBaseViewController *)viewController
{
    Video *featuredVideo = featuredContent.video ? : [[VimondStore videoStore] videoWithId:featuredContent.contentKey error:nil];
    if (featuredVideo)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            // Play the entity in video player
            [EntityVideoPlayBackViewController presentVideo:featuredVideo fromEntity:nil withNavigationController:viewController.navigationController];
             
        }];
    }
}

+ (void)handleFeaturedCategory:(FeaturedContent *)featuredContent withViewController:(GGBaseViewController *)viewController
{
    // TODO: Clean up this method.  It's a royal mess
    ContentCategory *category = featuredContent.category ? : [[VimondStore categoryStore] categoryWithId:featuredContent.contentKey error:nil];
    if (category)
    {
        if (category.categoryLevel <= ContentCategoryLevelSub)
        {
            [CategoryNavigator navigateToCategoryWithId:category.identifier fromViewController:viewController completionHandler:nil];
        }
        else if (category.categoryLevel == ContentCategoryLevelChannel)
        {
            Channel *channel = [[VimondStore channelStore] channelWithId:category.identifier error:nil];
            if (channel)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                {
                    [EntityModalViewController showFromView:nil withEntity:channel navController:viewController.navigationController];
                }];
            }
          
        }else if (category.categoryLevel == ContentCategoryLevelShow) // Handle click on show on content panel
        {
            Show *show = [[VimondStore showStore] showWithId:category.identifier error:nil];
            if (show)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                 {
                     [EntityModalViewController showFromView:nil withEntity:show navController:viewController.navigationController];
                 }];
            }
            
        }
    }
}

+ (void)handleFeaturedDispEntity:(FeaturedContent *)featuredContent withViewController:(GGBaseViewController *)viewController
{

    Entity* dispEntity = featuredContent.displayEntity ? : [[VimondStore channelStore] channelWithId:featuredContent.contentKey error:nil];
    DisplayEntity* entity = nil;
    if ([dispEntity isKindOfClass:[DisplayEntity class]]) {
        entity = (DisplayEntity*)dispEntity;
    }
    if (entity)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [EntityModalViewController showFromView:nil withEntity:entity navController:viewController.navigationController];
        }];
    }
}


// Handle click on bundle on Featured panel
+ (void)handleFeaturedBundle:(FeaturedContent *)featuredContent withViewController:(GGBaseViewController *)viewController
{
    
    Entity* dispEntity = featuredContent.displayEntity ? : [[VimondStore bundleStore] bundleWithId:featuredContent.contentKey error:nil];
    Bundle* bundle = nil;
    if ([dispEntity isKindOfClass:[Bundle class]]) {
        bundle = (Bundle*)dispEntity;
    }
    if (bundle)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             [EntityModalViewController showFromView:nil withEntity:bundle navController:viewController.navigationController];
         }];
    }
}

@end