//
//  ChannelModalViewControllerHelper.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelModalViewControllerHelper.h"
#import "ShowsForChannelDataFetcher.h"
#import "ShowTableCell.h"
#import "Show.h"
#import "Channel.h"
#import "PrefetchingDataSource.h"
#import "EntityModalViewSubElementsView.h"
#import "CAAnimation+Blocks.h"
#import "EntityModalViewControllerHelperFactory.h"
#import "ChannelsForCategoryDataFetcher.h"
#import "ChannelsFromPublisherDataFetcher.h"


#define kCellIdentifier @"channelmodalviewhelpercell"
#define REMOVE_SUBELEMENTSVIEW @"RemSubElements"

#define kFlipAnimationDuration 0.5
#define kPresentationAnimationDuration 0.2
#define kFadeInAnimationDuration 0.2
#define kElementPadding 3

@interface ChannelModalViewControllerHelper ()

@property (strong,nonatomic)ElementsView* subElementsView; 
@property (strong, nonatomic) EntityModalViewControllerHelper* controllerHelper;
@property (strong, nonatomic) ModalEntityRelatedViewController * relatedContentViewController;  
@property(nonatomic,strong)EntityModalViewController *entityModalviewController;

@property (strong, nonatomic) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) ObjectAsSourceDataFetcher *dataFetcher;
@property (weak, nonatomic) DisplayEntity* subDispEntityShown;
@end


@implementation ChannelModalViewControllerHelper

-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofCategory
{
    // data fetcher to fetch channels of same category returned
    return [ChannelsForCategoryDataFetcher new];
}


-(ObjectAsSourceDataFetcher*)getDataFetcherForEntityofPublisher
{
    // data fetcher to fetch channels of same publisher returned
    return [ChannelsFromPublisherDataFetcher new];
}

-(ObjectAsSourceDataFetcher*)getDataFetcher
{
    // data fetcher to fetch sub elements ie shows returned
    ShowsForChannelDataFetcher* fetcher = [ShowsForChannelDataFetcher new];
    return fetcher;
}

-(id)initWithEntity:(Entity*)displEntity navController:(UINavigationController*)navtnController
{
    
    NSAssert([displEntity isKindOfClass:[Channel class]], @"displEntity should of type channel");
    self = [super initWithEntity:displEntity navController:navtnController];
    return self;
}

-(int)getEntityLikeCount
{
    // get the number of likes entity has got
    return ((Channel*)self.dispEntity).likeCount;
}

-(NSString*)getNoSubElementsString
{
    return NSLocalizedString(@"ChannelHasNoShowsLKey", @"");
}

-(NSString*)getSubItemCountString:(NSUInteger)count
{
    return [NSString stringWithFormat:NSLocalizedString(@"NumberOfShowsLKey",@""), count];
}

-(NSString*)getEntityTypeString
{
    return NSLocalizedString(@"ChannelsLKey", @"");
}

-(NSString*)getSubItemNavigationBarTitle
{
    return NSLocalizedString(@"ShowsLKey", @"");
}

-(UITableViewCell*)getTableCell:(NSString*)cellIdentifier
{
    // Table cell to display sub elements
    UITableViewCell* cell = [[ShowTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    return cell;
}

-(void)setDataObjectForCell:(Entity*)entity cell:(UITableViewCell*)cellView
{
    // set data to a table cell
    NSAssert([cellView isKindOfClass:[ShowTableCell class]], @"Cell view should be of type ShowTableCell");
    NSAssert([entity isKindOfClass:[Show class]], @"Entity should be of type show");
    
    ShowTableCell* cell = (ShowTableCell*)cellView;
    cell.show = (Show*)entity;
}


-(void)rowSelectdonSubElementsTable:(UIView*)contentView rectSubView:(CGRect)rectSubview dataSource:(PrefetchingDataSource*)dataSource cell:(UITableViewCell*)cellAtPath
{
    // the following cell has been tapped.
    self.subDispEntityShown = [self getShowFromCell:(ShowTableCell*)cellAtPath];
    
    
    // sub elements view created to show sub elements of the table cell
    [self prepareSubElementsView:rectSubview];
    
    // data source and helper prepared
    [self prepareHelpersAndDataSource];
    
    // the new view is added with animation
    [self addSubViewWithAnimation:contentView];
    
    // The newly added view is updated with data
    [self updateFromEntity:self.subDispEntityShown];
    
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

// Obtain Show entity from a ShowTableCell
-(Show*)getShowFromCell:(ShowTableCell*)tableCell
{
    ShowTableCell* cell = (ShowTableCell*)tableCell;
    return cell.show;
}

// Add sub elements view with push animation
-(void)addSubViewWithAnimation:(UIView*)contentView
{
    [contentView addSubview:self.subElementsView];
    
    CATransition *animation = [self getPushLeftAnimation];
    [animation setDelegate:self];
    
    
    [[self.subElementsView layer]addAnimation:animation forKey:@"ADD_SUBELEMENTSVIEW"];
    [UIView commitAnimations];
}


// call back when animation is stopped
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (flag) {
        [self.delegate hideViewOnCompletionOfAnimation];
    }
}


-(void)hideViewOnCompletionOfAnimation
{
    
    [self.subElementsView hideTheViewWithElements];
}



- (void)setupTapRecognizers
{
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentRelatedContent)];
    [self.subElementsView.relatedContentView addGestureRecognizer:tapRecog];
    
    
}

// present related content view
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



// function to prepare sub elements
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
    NSString *backButtontitle=NSLocalizedString(@"ShowsLKey", @"");
    //NSLocalizedString(@"ChannelsLKey", @"")
    
    
    CGSize textSize = [backButtontitle sizeWithFont:textFont];
    float textWidth=textSize.width;
    //float textHeight=textSize.height;
    CGSize sizeButtonBgImage = bgImage.size;
    float offsetWidth = textWidth+sizeButtonBgImage.width;
    float offsetHeight=  sizeButtonBgImage.height;
    
    [self.subElementsView.backButton setFrame:CGRectMake(12.0,4.0,offsetWidth,offsetHeight)];
    [self.subElementsView.backButton setTitle:backButtontitle forState:UIControlStateNormal];
    
}


- (BOOL)canDisplayRelatedViewForEntity
{
    return YES;
}




- (void)updateFromEntity:(DisplayEntity *)entity
{
    if (entity == nil)
    {
        return;
    }
    
    self.dataFetcher.sourceObject = entity;
    
    if ([self canDisplayRelatedViewForEntity]) {
        [self.subElementsView showRelatedContentView];
    }else{
        [self.subElementsView hideRelatedContentView];
    }
    
    [self setupTapRecognizers]; 
    
    
    CGFloat pixelScale = [UIScreen mainScreen].scale;
    self.subElementsView.channelLogoView.imageURL = [self.controllerHelper getImageURLForEntity:CGSizeMake(self.subElementsView.channelLogoView.bounds.size.width  * pixelScale,                                                                                                 self.subElementsView.channelLogoView.bounds.size.height * pixelScale)]; 
    
    self.subElementsView.channelNameLabel.text          = entity.title;  
    
    
    
    if ([self.controllerHelper shouldDisplayParentalGuidance]) {
        [self.subElementsView.pgRatingView setHidden:NO];
        self.subElementsView.pgRatingView.rating  = [self.controllerHelper parentalGuidanceString];
    }else{
        [self.subElementsView.pgRatingView setHidden:YES];
    }
    
    self.subElementsView.publisherLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), [self.controllerHelper publisherAsString]];
    
    self.subElementsView.channelDescriptionLabel.text   = entity.summary;
    
    [self.subElementsView.channelInfoContainer setNeedsLayout];
    [[self.subElementsView titleSubSection] setText:self.subDispEntityShown.title]; 
    
    self.subElementsView.videoTableView.hidden = YES;
    self.subElementsView.videoCountLabel.hidden = YES;
    
    
    
    
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
    UITableViewCell *videoTableCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (videoTableCell == nil)
    {
        // Get the table cell from helper
        videoTableCell = [self.controllerHelper getTableCell:kCellIdentifier];
    }
    
    // fetch data from data source
    [self.dataSource fetchDataObjectAtIndex:(NSUInteger) indexPath.row
                             successHandler:^(NSObject *dataObject)
     {
         [self.controllerHelper setDataObjectForCell:(Entity*)dataObject cell:videoTableCell];
     } errorHandler:nil];
    
    if(indexPath.row == 0)
        [videoTableCell setAccessibilityLabel:@"ChannelModal"];
    //Home
    if(indexPath.row ==3)
        [videoTableCell setAccessibilityLabel:@"HomeChannelModal"];
    
    
    return videoTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when a sub view cell is tapped controllerhelper is called
    CGRect rectSubView = self.subElementsView.bounds;  
    [self.controllerHelper rowSelectdonSubElementsTable:self.subElementsView rectSubView:rectSubView dataSource:self.dataSource cell:[tableView cellForRowAtIndexPath:indexPath]];
}

-(NSString*)getImageURLForEntity:(CGSize)sizeImg
{
    Channel* chnl = (Channel*)self.dispEntity;
    return [chnl logoURLStringForSize:sizeImg];
}

// Parental guidance needs to be shown for channel
-(BOOL)shouldDisplayParentalGuidance
{
    return YES;
}

// Parental guidance string to be shown
-(PGRating)parentalGuidanceString
{
    return ((Channel*)self.dispEntity).pgRating;
}

-(NSString*)publisherAsString
{
    return ((Channel*)self.dispEntity).publisher;
}


-(void)backButtonTapped
{
    [self.delegate backButtonTappedOnSubElementsView];
}


# pragma mark - Delegate functions of related view controller

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


#pragma mark - Properties

- (void)setSubDispEntityShown:(DisplayEntity *)subDispEntityShown
{
    self.controllerHelper.dispEntity = subDispEntityShown;
    _subDispEntityShown = subDispEntityShown;
    [self updateFromEntity:_subDispEntityShown];
}
@end
