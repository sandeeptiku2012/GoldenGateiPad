//
//  EntityModalViewControllerHelper.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "ObjectAsSourceDataFetcher.h"
#import "PrefetchingDataSource.h"
#import "Constants.h"
#import "CAAnimation+Blocks.h"
#import "ModalEntityRelatedViewController.h"

@class ElementsView;
@class EntityModalViewController;
@class EntityModalViewControllerHelper;

@protocol EntityModalViewControllerHelperDelegate <NSObject>

@optional
-(void) backButtonTappedOnSubElementsView;
-(void) hideViewOnCompletionOfAnimation ;

@end


@interface EntityModalViewControllerHelper : NSObject <ModalEntityRelatedViewControllerDelegate>

@property (weak, nonatomic) id<EntityModalViewControllerHelperDelegate>delegate;



@property (strong, nonatomic)Entity* dispEntity;
@property (weak, nonatomic) UINavigationController *navController; // Used for presenting videos

// initialize the helper with data entity
-(id)initWithEntity:(Entity*)dispEntity navController:(UINavigationController*)navtnController;

// obtain data fetcher to fetch entity having same category
-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofCategory;

// obtain data fetcher to get entities of same publisher
-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofPublisher;

// obtain data fetcher to obtain sub elements
-(ObjectAsSourceDataFetcher*)getDataFetcher;

// get localized string value to denote the entity
-(NSString*)getEntityTypeString;

// get like count for entity
-(int)getEntityLikeCount;

// get localized string to display when there is no sub element
-(NSString*)getNoSubElementsString;

// get localized string to display number of sub elements
-(NSString*)getSubItemCountString:(NSUInteger)count;

// get localized title text for sub item navigation bar title
-(NSString*)getSubItemNavigationBarTitle;

// get table cell to be used to display sub elements of the entity
-(UITableViewCell*)getTableCell:(NSString*)cellIdentifier;

// set the data object for a table cell
-(void)setDataObjectForCell:(Entity*)entity cell:(UITableViewCell*)cellView;

// get the image URL
-(NSString*)getImageURLForEntity:(CGSize)sizeImg;

// Function returns if Parental guidance has to be displayed
-(BOOL)shouldDisplayParentalGuidance;

// Parental guidance string
-(PGRating)parentalGuidanceString;

-(NSString*)publisherAsString;

// the function called when a row in sub elements view is tapped
-(void)rowSelectdonSubElementsTable:(UIView*)contentView rectSubView:(CGRect)rectSubview dataSource:(PrefetchingDataSource*)dataSource cell:(UITableViewCell*)cellAtPath;

// get the push left animation to add a new view
-(CATransition*)getPushLeftAnimation;


// function returns if related content view has to be displayed
- (BOOL)canDisplayRelatedViewForEntity;



//the function called when the related content View is taped
+(void)presentRelatedContentForEntity:(Entity*)entity relatedContentViewController:(ModalEntityRelatedViewController *)relatedContentViewController elementsView:(ElementsView *)elementsView entityModalViewController:(EntityModalViewController *)entityModalViewController andNavController:(UINavigationController *)navController andDismisstarget:(id)dismissTarget;


//the function Called when the back button in related content view is taped
+(void)dismissRelatedView:(ElementsView*)elementsView relatedContentViewController:(ModalEntityRelatedViewController *)relatedContentViewController;



@end
