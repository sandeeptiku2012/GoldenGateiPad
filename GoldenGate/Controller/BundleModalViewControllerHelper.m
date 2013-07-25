//
//  BundleModalViewControllerHelper.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 19/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "BundleModalViewControllerHelper.h"
#import "ChannelsForBundleDataFetcher.h"
#import "Bundle.h"
#import "Channel.h"
#import "ChannelTableCell.h"
#import "PrefetchingDataSource.h"
#import "EntityModalViewSubElementsView.h"
#import "CAAnimation+Blocks.h"
#import "EntityModalViewControllerHelperFactory.h"
#import "EntityModalViewController.h"
#import "ModalEntityRelatedViewController.h"


#define kCellIdentifier @"bundlemodalviewhelpercell"
#define REMOVE_SUBELEMENTSVIEW @"RemSubElements"

#define kFlipAnimationDuration 0.5
#define kPresentationAnimationDuration 0.2
#define kFadeInAnimationDuration 0.2
#define kElementPadding 3


@interface BundleModalViewControllerHelper ()

@property(strong, nonatomic) ElementsView *subElementsView; 
@property(nonatomic,strong)EntityModalViewController *entityModalviewController;
@property (strong, nonatomic) EntityModalViewControllerHelper* controllerHelper;
@property (strong, nonatomic) ModalEntityRelatedViewController * relatedContentViewController; 

@property (strong, nonatomic) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) ObjectAsSourceDataFetcher *dataFetcher;
@property (weak, nonatomic) DisplayEntity* subDispEntityShown;
@end

@implementation BundleModalViewControllerHelper

-(ObjectAsSourceDataFetcher*)getDataFetcher
{
    // data fetcher to fetch sub elements of a bundle ie channels returned
    ChannelsForBundleDataFetcher* fetcher = [ChannelsForBundleDataFetcher new];
    return fetcher;
}

-(NSString*)getNoSubElementsString
{
    return NSLocalizedString(@"BundleHasNoChannelsLKey", @"");
}

-(NSString*)getSubItemCountString:(NSUInteger)count
{
    return [NSString stringWithFormat:NSLocalizedString(@"NumberOfChannelsLKey",@""), count];
}


-(NSString*)getSubItemNavigationBarTitle
{
    return NSLocalizedString(@"ChannelsLKey", @"");
}

-(UITableViewCell*)getTableCell:(NSString*)cellIdentifier
{
    // Table cell to display sub elements. For bundle sub elements are channels
    UITableViewCell* cell = [[ChannelTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    return cell;
}


-(void)setDataObjectForCell:(Entity*)entity cell:(UITableViewCell*)cellView
{
    // set data to a table cell
    NSAssert([cellView isKindOfClass:[ChannelTableCell class]], @"Cell view should be of type ChannelTableCell");
    NSAssert([entity isKindOfClass:[Channel class]], @"Entity should be of type channel");
    
    ChannelTableCell* cell = (ChannelTableCell*)cellView;
    cell.channel = (Channel*)entity;
}


// this function called when any of the table cell displaying sub element ie channel is tapped. In this function new view
// to display shows is added with animation
-(void)rowSelectdonSubElementsTable:(UIView*)contentView rectSubView:(CGRect)rectSubview dataSource:(PrefetchingDataSource*)dataSource cell:(UITableViewCell*)cellAtPath
{
    // the following cell has been tapped.
    self.subDispEntityShown = [self getChannelFromCell:(ChannelTableCell*)cellAtPath];
    
    
    // sub elements view created to show sub elements of the table cell
    [self prepareSubElementsView:rectSubview];
    
    //self.entityModalviewController=[[EntityModalViewController alloc]initWithEntity:self.subDispEntityShown andNavigationController:self.navController];
    
    
    // data source and helper prepared
    [self prepareHelpersAndDataSource];
    
    // the new view is added with animation
    [self addSubViewWithAnimation:contentView];
    
    // The newly added view is updated with data
    [self updateFromEntity:self.subDispEntityShown];
    
}





// Obtain Show entity from a ShowTableCell
-(Channel*)getChannelFromCell:(ChannelTableCell*)tableCell
{
    ChannelTableCell* cell = (ChannelTableCell*)tableCell;
    return cell.channel;
}


- (void)setupTapRecognizers
{
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentRelatedContent)];
    [self.subElementsView.relatedContentView addGestureRecognizer:tapRecog];
    
}



- (void)presentRelatedContent
{
    if (nil == self.relatedContentViewController) {
        self.relatedContentViewController = [ModalEntityRelatedViewController new];
    }
    
    [EntityModalViewControllerHelper presentRelatedContentForEntity:self.subDispEntityShown
                                       relatedContentViewController:self.relatedContentViewController
                                                       elementsView:self.subElementsView
                                          entityModalViewController:self.entityModalviewController
                                                   andNavController:self.navController
                                                   andDismisstarget:self];
    
    
    
}



// function to prepare sub elements view
-(void)prepareSubElementsView:(CGRect)rectSubView
{
    
    
    
    self.subElementsView = [[ElementsView alloc]init];
    
    [self.subElementsView setFrame:rectSubView]; 
    
    
    
    
    [[self.subElementsView videoTableView] setDelegate:self];
    [[self.subElementsView videoTableView] setDataSource:self];
    [[self.subElementsView loadingView] setDelegate:self];
    [self.subElementsView setDelegate:self];
    
    
    UIImage* bgImage = [UIImage imageNamed:@"BackButtonBg.png"];
    UIFont* textFont = [UIFont boldSystemFontOfSize:12];
    NSString *backButtontitle=NSLocalizedString(@"ChannelsLKey", @"");
    
    
    CGSize textSize = [backButtontitle sizeWithFont:textFont];
    float textWidth=textSize.width;
    //float textHeight=textSize.height;
    CGSize sizeButtonBgImage = bgImage.size;
    float offsetWidth = textWidth+sizeButtonBgImage.width;
    float offsetHeight=  sizeButtonBgImage.height;
    
    [self.subElementsView.backButton setFrame:CGRectMake(12.0,4.0,offsetWidth,offsetHeight)];
    [self.subElementsView.backButton setTitle:backButtontitle forState:UIControlStateNormal]; 
    
    
    
}

-(void)prepareHelpersAndDataSource
{
    // helper created based on entity type
    self.controllerHelper = [EntityModalViewControllerHelperFactory createModalViewControllerHelperForEntity:self.subDispEntityShown withNavController:self.navController];
    [self.controllerHelper setDelegate:self];
    
    // data fetcher to display sub elements obtained
    self.dataFetcher = [self.controllerHelper getDataFetcher];
    
    // data source created
    self.dataSource = [PrefetchingDataSource createWithDataFetcher:self.dataFetcher];
}


// Add sub elements view with push animation
-(void)addSubViewWithAnimation:(UIView*)contentView
{
    
    UIView* viewToAdd = self.subElementsView;
    [contentView addSubview:viewToAdd];
    
    CATransition *animation = [self getPushLeftAnimation];
    [animation setDelegate:self];
    
    
    
    [[viewToAdd layer]addAnimation:animation forKey:@"ADD_SUBELEMENTSVIEW"];
    [UIView commitAnimations];
    
}


// Function called when animation is done
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
    if (flag) {
        
        [self.delegate hideViewOnCompletionOfAnimation];
        
    }
}



-(void)hideViewOnCompletionOfAnimation{
    
    [self.subElementsView hideTheViewWithElements];
}





- (BOOL)canDisplayRelatedViewForEntity
{
    return NO;
}



- (void)updateFromEntity:(DisplayEntity *)entity
{
    if (entity == nil)
    {
        return;
    }
    
    self.dataFetcher.sourceObject = entity;
    
    
    
    if ([self canDisplayRelatedViewForEntity]) {
        [self.subElementsView hideRelatedContentView];
    }else{
        [self.subElementsView showRelatedContentView];
    }
    
    [self setupTapRecognizers]; 
    
    CGFloat pixelScale = [UIScreen mainScreen].scale;
    self.subElementsView.channelLogoView.imageURL       = [self.controllerHelper getImageURLForEntity:CGSizeMake(self.subElementsView.channelLogoView.bounds.size.width  * pixelScale,                                                                                                                 self.subElementsView.channelLogoView.bounds.size.height * pixelScale)]; 
    
    self.subElementsView.channelNameLabel.text          = entity.title; 
    
    
    if ([self.controllerHelper shouldDisplayParentalGuidance]) {
        [self.subElementsView.pgRatingView setHidden:NO];
        self.subElementsView.pgRatingView.rating   = [self.controllerHelper parentalGuidanceString];
    }
    else{
        [self.subElementsView.pgRatingView setHidden:YES];
    }
    
    
    self.subElementsView.publisherLabel.text            = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), [self.controllerHelper publisherAsString]];  
    
    
    [[self.subElementsView titleSubSection] setText:self.subDispEntityShown.title ]; 
    
    self.subElementsView.channelDescriptionLabel.text   = entity.summary;   
    
    [self.subElementsView.channelInfoContainer setNeedsLayout];            
    
    
    
    
    
    [self reloadTable];
    
    
    
}

// reload sub elements view table
-(void)reloadTable
{
    // display loading view
    [self.subElementsView.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    
    // data fetched
    [self.dataSource fetchDataObjectAtIndex:0
                             successHandler:^(NSObject *dataObject)
     {
         // table in subelementsview reloaded
         [self.subElementsView.videoTableView reloadData];
         self.subElementsView.videoTableView.hidden = NO;
         
         // end loading view
         [self.subElementsView.loadingView endLoading];
         
         // display message if no values present
         if (self.dataSource.cachedTotalItemCount == 0)
         {
             [self.subElementsView.loadingView showMessage:[self.controllerHelper getNoSubElementsString] ];
         }
     }
                               errorHandler:^(NSError *error)
     {
         [self.subElementsView.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
         self.subElementsView.videoTableView.hidden = YES;
     }];
}


#pragma mark - loading view callbacks

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self updateFromEntity:self.subDispEntityShown];
}

#pragma mark - table view call backs


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.cachedTotalItemCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *channelTableCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (channelTableCell == nil)
    {
        // Get the table cell from helper
        channelTableCell = [self.controllerHelper getTableCell:kCellIdentifier];
    }
    
    // fetch data from data source
    [self.dataSource fetchDataObjectAtIndex:(NSUInteger) indexPath.row
                             successHandler:^(NSObject *dataObject)
     {
         [self.controllerHelper setDataObjectForCell:(Entity*)dataObject cell:channelTableCell];
     } errorHandler:nil];
    
    return channelTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when a sub view cell is tapped controllerhelper is called
    CGRect rectSubView = self.subElementsView.bounds; 
    
    [self.controllerHelper rowSelectdonSubElementsTable:self.subElementsView rectSubView:rectSubView dataSource:self.dataSource cell:[tableView cellForRowAtIndexPath:indexPath]];
}

-(NSString*)getImageURLForEntity:(CGSize)sizeImg
{
    Bundle* bundle = (Bundle*)self.dispEntity;
    return [bundle logoURLStringForSize:sizeImg];
}





-(NSString*)publisherAsString
{
    return ((Bundle*)self.dispEntity).publisher;
}




-(void)backButtonTapped
{
    
    [self.delegate backButtonTappedOnSubElementsView];
}

-(void)backButtonTappedOnSubElementsView
{
    
    [self.subElementsView showTheViewWithElements];
}


#pragma mark - properties


-(void)setSubDispEntityShown:(DisplayEntity *)subDispEntityShown
{
    self.controllerHelper.dispEntity = subDispEntityShown;
    _subDispEntityShown = subDispEntityShown;
    [self updateFromEntity:_subDispEntityShown];

}


#pragma mark - Delegate functions of related view

-(void)backButtonTappedOnRelated
{
    [EntityModalViewControllerHelper dismissRelatedView:self.subElementsView relatedContentViewController:self.relatedContentViewController];
}


-(void)cellOnGridTappedOnRelatedContentViewWithEntity:(Entity *)entity
{
    if (entity) {
        if ([entity isKindOfClass:[DisplayEntity class]]) {
            self.subDispEntityShown =(DisplayEntity*)entity;
        }        
    }
    
    [self backButtonTappedOnRelated];
}


@end
