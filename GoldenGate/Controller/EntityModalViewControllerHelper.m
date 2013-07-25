//
//  EntityModalViewControllerHelper.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "EntityModalViewControllerHelper.h"
#import "PrefetchingDataSource.h"
#import "ElementsView.h"



#define kFlipAnimationDuration 0.5
#define kPresentationAnimationDuration 0.2
#define kFadeInAnimationDuration 0.2
#define kElementPadding 3


@interface EntityModalViewControllerHelper ()



@end

@implementation EntityModalViewControllerHelper


// Satish TBD: Refactor all subclasses once the EntityModalViewController UI design is finalized

-(id)initWithEntity:(Entity*)displEntity navController:(UINavigationController*)navtnController
{
    if (self = [super init]) {
        _dispEntity = displEntity;
        _navController = navtnController;
    }
    
    return self;
}

-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofCategory
{
    return nil;
}

-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofPublisher
{
    return nil;
}

-(ObjectAsSourceDataFetcher*)getDataFetcher
{
    return nil;
}

-(int)getEntityLikeCount
{
    return 0;
}

-(NSString*)getNoSubElementsString
{
    return @"";
}

-(NSString*)getSubItemCountString:(NSUInteger)count
{
    return @"";
}
-(NSString*)getSubItemNavigationBarTitle
{
    return @"";
}

-(NSString*)getEntityTypeString
{
    return nil;
}

-(UITableViewCell*)getTableCell:(NSString*)cellIdentifier
{
    return nil;
}
-(void)setDataObjectForCell:(Entity*)entity cell:(UITableViewCell*)cellView
{
    
}

-(void)rowSelectdonSubElementsTable:(UIView*)contentView rectSubView:(CGRect)rectSubview dataSource:(PrefetchingDataSource*)dataSource cell:(UITableViewCell*)cellAtPath
{
    
}

-(NSString*)getImageURLForEntity:(CGSize)sizeImg
{
    return nil;
}


-(BOOL)shouldDisplayParentalGuidance
{
    return NO;
}

-(PGRating)parentalGuidanceString
{
    return PgRatingNotRated;
}

-(NSString*)publisherAsString
{
    return nil;
}


// create animation to push the view left
-(CATransition*)getPushLeftAnimation
{
    CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
    [animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return animation;
}



+(void)presentRelatedContentForEntity:(Entity*)entity relatedContentViewController:(ModalEntityRelatedViewController *)relatedContentViewController elementsView:(ElementsView *)elementsView entityModalViewController:(EntityModalViewController *)entityModalViewController andNavController:(UINavigationController *)navController andDismisstarget:(id)dismissTarget
{
    if ([ModalEntityRelatedViewController canDisplayRelatedViewForEntity:entity] )
    {
        relatedContentViewController.entityModalViewController = entityModalViewController;
        relatedContentViewController.navController = navController;
        relatedContentViewController.delegate = dismissTarget;
        
        
        relatedContentViewController.dispEntity = (DisplayEntity*)entity;
        
        [UIView transitionWithView:elementsView duration:kFlipAnimationDuration
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^
         {
             elementsView.viewWithElements.hidden = YES;
             
             [elementsView addSubview:relatedContentViewController.view];
             
         }
                        completion:^(BOOL finished)
         {
             [relatedContentViewController fadeInNavBar];
         }];
    }
    
}

+(void)dismissRelatedView:(ElementsView*)elementsView relatedContentViewController:(ModalEntityRelatedViewController *)relatedContentViewController
{
    [UIView transitionWithView:elementsView duration:kFlipAnimationDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^
     {
         [relatedContentViewController.view removeFromSuperview];
         elementsView.viewWithElements.hidden = NO;
         [elementsView addSubview:elementsView.viewWithElements];
     }
                    completion:^(BOOL finished)
     {
         // Hack: Have to do this since this view never lives on the navigation stack
         //[self viewDidAppear:YES];
     }];
}



-(void)backButtonTappedOnRelated
{
    //override if action has to be taken
    
}




- (BOOL)canDisplayRelatedViewForEntity
{
    BOOL retVal=YES;
    return retVal;
}






@end
