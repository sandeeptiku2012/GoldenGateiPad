//
//  ElementsView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 25/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVImageView.h"
#import "PGRatingView.h"
#import "LoadingView.h"
#import "LikeLabel.h"
#import "EntityModalViewControllerHelper.h"

@class ElementsView;


@protocol ElementsViewDelegate <NSObject>

@optional

-(void)backButtonTapped;

@end

@interface ElementsView : UIView <EntityModalViewControllerHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel         *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel         *titleSubSection;
@property (weak, nonatomic) IBOutlet UILabel         *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel         *channelDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel         *publisherLabel;
@property (weak, nonatomic) IBOutlet TVImageView     *channelLogoView;
@property (weak, nonatomic) IBOutlet UITableView     *videoTableView;
@property (weak, nonatomic) IBOutlet PGRatingView    *pgRatingView;
@property (weak, nonatomic) IBOutlet LoadingView     *loadingView;
@property (weak, nonatomic) IBOutlet UIView          *relatedContentView;
@property (weak, nonatomic) IBOutlet UILabel         *relatedContentViewLabel;
@property (weak, nonatomic) IBOutlet UIImageView         *relatedContentViewImage;
@property (weak, nonatomic) IBOutlet UIView          *contentView;
@property (weak, nonatomic) IBOutlet UIView          *channelInfoContainer;
@property (weak, nonatomic) IBOutlet LikeLabel       *likeLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton         *backButton;
@property (weak, nonatomic) UIView* viewWithElements;

@property (weak, nonatomic)id <ElementsViewDelegate> delegate;

-(void)initFromNibCustom;
- (IBAction) backClicked: (id) sender;

-(void) showRelatedContentView;
-(void) hideRelatedContentView;

// to hide and show the elements of the elements view
-(void) hideTheViewWithElements;
-(void) showTheViewWithElements;


// show or hide back button
-(void)hideBackButton:(BOOL)bHide;



@end
