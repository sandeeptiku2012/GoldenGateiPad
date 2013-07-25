//
//  EntityModalViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "EntityModalViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Channel.h"
#import "PGRatingView.h"
#import "Video.h"
#import "VideoTableCell.h"
#import "VideoPlaybackViewController.h"
#import "ModalEntityRelatedViewController.h"
#import "VimondStore.h"
#import "LikeBarButton.h"
#import "TVImageView.h"
#import "LikeLabel.h"
#import "ChannelCellView.h"
#import "VideosForChannelDataFetcher.h"
#import "ProgramSortUIName.h"
#import "NavActionExecutor.h"
#import "GGUsageTracker.h"
#import "EntityCellView.h"
#import "EntityModalViewControllerHelperFactory.h"
#import "ElementsView.h"
#import "ShowTableCell.h"

#define kCellIdentifier @"VideoTableCell"
#define kFlipAnimationDuration 0.5
#define kPresentationAnimationDuration 0.2
#define kFadeInAnimationDuration 0.2
#define kElementPadding 3
#define kLastUsedSortModeKeyName @"channelViewLastUsedSortMode"

static EntityModalViewController *gInstance;

@interface EntityModalViewController ()
@property (nonatomic,strong) IBOutlet ElementsView *elementsView;

@property (weak, nonatomic) IBOutlet UIView          *tapToDismissView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

@property (weak, nonatomic) UIView *sourceChannelView; // The view that was tapped to present the channelview controller.

@property (strong, nonatomic) ModalEntityRelatedViewController * relatedContentViewController;
@property (strong, nonatomic) VideoPlaybackViewController *videoPlaybackViewController;

@property (strong, nonatomic) PrefetchingDataSource *dataSource;
@property (strong, nonatomic) ObjectAsSourceDataFetcher *dataFetcher;

// Store initial rect of the channel description label so it can be used as a max value for this height.
@property (assign, nonatomic) CGRect maxChannelDescriptionLabelFrame;

@property (assign, nonatomic) CGFloat maxChannelInfoContainerHeight;

@property (strong, nonatomic) EntityModalViewControllerHelper* controllerHelper;

@end

@implementation EntityModalViewController


+ (BOOL)shouldAnimateWhenPresentingFromView:(UIView*)view
{
    BOOL shouldAnimate = view != nil && view.frame.size.height / view.frame.size.width;
    
    // Only animate relatively a certain group of cells
    if ([view isKindOfClass:[CellView class]])
    {
        CellView *cell = (CellView*)view;
        shouldAnimate = cell.cellSize <= CellSizeLarge;
    }
    
    return shouldAnimate;
}

+ (void)showFromView:(UIView *)view withEntity:(DisplayEntity *)entity navController:(UINavigationController *)navController
{
    if (gInstance == nil || gInstance.view.superview == nil)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDismissSearchPopover object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNavigationPopoverDismiss object:nil];
        
        
        
        EntityModalViewController *entityViewController = [EntityModalViewController new];
        
        entityViewController.dispEntity = entity;
        entityViewController.navController = navController;
        entityViewController.sourceChannelView = view;
        entityViewController.controllerHelper = [EntityModalViewControllerHelperFactory createModalViewControllerHelperForEntity:entity withNavController:navController];
        [entityViewController.controllerHelper setDelegate:entityViewController];
        gInstance = entityViewController;
        
        [[self overlayView]addSubview:entityViewController.view];
        
        if ([self shouldAnimateWhenPresentingFromView:view])
        {
            entityViewController.sourceChannelView.hidden = YES;
            [entityViewController animateView:entityViewController.elementsView
                                     fromView:view
                                       toView:entityViewController.elementsView
                                  reverseAnim:NO];
        }
        else
        {
            entityViewController.view.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^
             {
                 entityViewController.view.alpha = 1;
             }];
        }
        
        
        entityViewController.tapToDismissView.alpha = 0;
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^
         {
             entityViewController.tapToDismissView.alpha = kDimmingViewAlpha;
         }];
        
        // Hack: Have to do this since this view never lives on the navigation stack
        [entityViewController viewDidAppear:YES];
    }
}



- (id)init
{
    NSString *nibName = NSStringFromClass([self class]);
    if ((self = [self initWithNibName:nibName bundle:nil]))
    {
        
    }
    
    
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)dealloc
{
    gInstance = nil;
}

/*!
 Views do not recognize taps, so here we add gesture recognizers to
 figure out if user tapped Related content in upper right corner or outside
 dialog to dismiss it.
 */
- (void)setupTapRecognizers
{
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentRelatedContent)];
    
    [self.elementsView.relatedContentView addGestureRecognizer:tapRecog];
    
    
    UITapGestureRecognizer *dismissTapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    [dismissTapRecog setAccessibilityLabel:@"Shows"];
    [self.tapToDismissView addGestureRecognizer:dismissTapRecog];
    self.tapToDismissView.layer.zPosition = -1;
}



- (void)viewDidLoad
{
    // Change style before super viewDidLoad so that the labels get proper localization.
    self.elementsView.loadingView.style = LoadingViewStyleForLightBackground;
    
    [super viewDidLoad];
    [self.elementsView initFromNibCustom];
    [self.elementsView hideBackButton:YES];
    [[self.elementsView videoTableView] setDelegate:self];
    [[self.elementsView videoTableView] setDataSource:self];
    [[self.elementsView loadingView] setDelegate:self];
    [self.elementsView setDelegate:self];
    
    
    self.maxChannelDescriptionLabelFrame   = self.elementsView.channelDescriptionLabel.frame;
    self.maxChannelInfoContainerHeight      = self.elementsView.channelInfoContainer.frame.size.height;
    
    
    [self setupTapRecognizers];
    
    [self updateFromEntity:self.dispEntity];
    

}





- (void)presentRelatedContent
{
    if (nil == self.relatedContentViewController) {
        self.relatedContentViewController = [ModalEntityRelatedViewController new];
    }
    
    [EntityModalViewControllerHelper presentRelatedContentForEntity:self.dispEntity
                                       relatedContentViewController:self.relatedContentViewController
                                                       elementsView:self.elementsView
                                          entityModalViewController:self
                                                   andNavController:self.navController
                                                   andDismisstarget:self];

}



-(void)cellOnGridTappedOnRelatedContentViewWithEntity:(Entity *)entity
{
    if (entity) {
        self.dispEntity = entity;
    }
    
    [EntityModalViewControllerHelper dismissRelatedView:self.elementsView relatedContentViewController:self.relatedContentViewController];
}


-(void)backButtonTappedOnRelated
{
    
    [EntityModalViewControllerHelper dismissRelatedView:self.elementsView relatedContentViewController:self.relatedContentViewController];
    
}







- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self.elementsView.videoTableView deselectRowAtIndexPath:self.elementsView.videoTableView.indexPathForSelectedRow animated:YES];
}




- (void)updateLikeCountFromChannel:(Channel*)channel
{
    self.elementsView.likeLabel.likeCount = [self.controllerHelper getEntityLikeCount];
}




- (void)reloadTable
{
    [self.elementsView.loadingView startLoadingWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    [self.dataSource fetchDataObjectAtIndex:0
                             successHandler:^(NSObject *dataObject)
     {
         [self.elementsView.videoTableView reloadData];
         self.elementsView.videoTableView.hidden = NO;
         self.elementsView.videoCountLabel.hidden = NO;
         [self.elementsView.loadingView endLoading];
         
         
         [self updateVideoCountLabelWithCount:self.dataSource.cachedTotalItemCount];
         
         if (self.dataSource.cachedTotalItemCount == 0)
         {
             [self.elementsView.loadingView showMessage:[self.controllerHelper getNoSubElementsString] ];
         }
     }
                               errorHandler:^(NSError *error)
     {
         [self.elementsView.loadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
         self.elementsView.videoTableView.hidden = YES;
     }];
}





- (void)updateFromEntity:(Entity *)entity
{
    if (entity == nil || !self.isViewLoaded)
    {
        return;
    }
    
    
    
    self.dataFetcher.sourceObject = entity;
    
    
    if ([ModalEntityRelatedViewController canDisplayRelatedViewForEntity:(DisplayEntity*)entity]) {
        //display related contentview
        [self.elementsView showRelatedContentView];
    }else{
        //hide related contentview
        [self.elementsView hideRelatedContentView];
    }
    
    
    CGFloat pixelScale = [UIScreen mainScreen].scale;
    self.elementsView.channelLogoView.imageURL       = [self.controllerHelper getImageURLForEntity:CGSizeMake(self.elementsView.channelLogoView.bounds.size.width  * pixelScale,                                                                                                 self.elementsView.channelLogoView.bounds.size.height * pixelScale)];
    
    
    self.elementsView.channelNameLabel.text          = entity.title;
    if ([self.controllerHelper shouldDisplayParentalGuidance]) {
        [self.elementsView.pgRatingView setHidden:NO];
        self.elementsView.pgRatingView.rating            = [self.controllerHelper parentalGuidanceString];
    }else{
        [self.elementsView.pgRatingView setHidden:YES];
    }
    
    self.elementsView.publisherLabel.text            = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), [self.controllerHelper publisherAsString]];
    self.elementsView.channelDescriptionLabel.text   = entity.summary;
    [self.elementsView.channelInfoContainer setNeedsLayout];
    
    self.elementsView.videoTableView.hidden = YES;
    self.elementsView.videoCountLabel.hidden = YES;
    self.elementsView.titleSubSection.text = [self.controllerHelper getSubItemNavigationBarTitle];
    [self reloadTable];
    
    self.likeButton.customView.hidden = YES;
    
}


- (void)updateVideoCountLabelWithCount:(NSUInteger)videoCount
{
    self.elementsView.videoCountLabel.text = [self.controllerHelper getSubItemCountString:videoCount];
}


- (void)setDispEntity:(Entity *)dispEntity
{
    _dispEntity = dispEntity;
    _controllerHelper.dispEntity = dispEntity;
    [self updateFromEntity:dispEntity];
}



- (IBAction)dismiss:(id)sender
{
    BOOL shouldAnimate = [EntityModalViewController shouldAnimateWhenPresentingFromView:self.sourceChannelView];
    
    if (shouldAnimate)
    {
        
        [self animateView:self.elementsView fromView:self.sourceChannelView toView:self.elementsView reverseAnim:YES];
    }
    
    [UIView animateWithDuration:kFadeInAnimationDuration animations:^
     {
         self.tapToDismissView.alpha = 0;
         
         if (!shouldAnimate)
         {
             self.elementsView.alpha = 0;
         }
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         self.sourceChannelView.hidden = NO;
         gInstance = nil;
     }];
}

/*!
 This method is used for animating the view from the cell a user presses to the final size of the view.
 @param view The view to whichthe animation actually will be applied.
 @param fromView defines the starting position of the animation
 @param fromView defines the ending position of the animation
 @param reverse if YES the animation will be reversed.
 */
- (void)animateView:(UIView*)view fromView:(UIView*)fromView toView:(UIView*)toView reverseAnim:(BOOL)reverse
{
    CGRect startRect = [self.view convertRect:fromView.frame fromView:fromView.superview];
    
    CGFloat halfWidth   = self.view.frame.size.width  / 2;
    CGFloat halfHeight  = self.view.frame.size.height / 2;
    
    // Wrap transform in value so that it can be in the keyframe array.
    NSValue *initialTransformValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    // move to location of channel tile in MainCategory
    CATransform3D translation = CATransform3DMakeTranslation(startRect.origin.x + (startRect.size.width / 2)  - halfWidth,
                                                             startRect.origin.y + (startRect.size.height / 2) - halfHeight,
                                                             0.0);
    
    CGFloat xScaleFactor = fromView.bounds.size.width  / toView.bounds.size.width;
    CGFloat yScaleFactor = fromView.bounds.size.height / toView.bounds.size.height;
    
    CATransform3D scalingAndTranslation = CATransform3DScale(translation, xScaleFactor, yScaleFactor, 1.0);
    CATransform3D finalTransform = CATransform3DRotate(scalingAndTranslation, 0 , 0.0, 1.0, 0.0);
    
    NSArray *keyFrameValues = reverse ?
    [NSArray arrayWithObjects:initialTransformValue, [NSValue valueWithCATransform3D:finalTransform], nil] :
    [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:finalTransform], initialTransformValue, nil];
    
    CAKeyframeAnimation *myAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    myAnimation.values = keyFrameValues;
    myAnimation.duration = kPresentationAnimationDuration;
    myAnimation.removedOnCompletion = NO;
    myAnimation.fillMode = kCAFillModeForwards;
    
    
    [self.elementsView.layer addAnimation:myAnimation forKey:@"myAnimationKey"];

}


+ (UIView*)overlayView
{
    return [[[[UIApplication sharedApplication]keyWindow]subviews]objectAtIndex:0];
}


- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self updateFromEntity:self.dispEntity];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.cachedTotalItemCount;
}


#pragma mark - Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.accessibilityLabel=@"Entityvideo";
    UITableViewCell *videoTableCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (videoTableCell == nil)
    {
        videoTableCell = [self.controllerHelper getTableCell:kCellIdentifier];
    }
    
    [self.dataSource fetchDataObjectAtIndex:(NSUInteger) indexPath.row
                             successHandler:^(NSObject *dataObject)
     {
         [self.controllerHelper setDataObjectForCell:(Entity*)dataObject cell:videoTableCell];
     } errorHandler:nil];
    if(indexPath.row==2)
        [videoTableCell setAccessibilityLabel:@"EntityModal"];
    return videoTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect rectSubView = self.elementsView.bounds; 
    
    [self.controllerHelper rowSelectdonSubElementsTable:self.elementsView rectSubView:rectSubView dataSource:self.dataSource cell:[tableView cellForRowAtIndexPath:indexPath]];
}





#pragma mark - Properties

- (PrefetchingDataSource*)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [PrefetchingDataSource createWithDataFetcher:self.dataFetcher];
    }
    
    return _dataSource;
}

- (ObjectAsSourceDataFetcher *)dataFetcher
{
    if (_dataFetcher == nil)
    {
        _dataFetcher = [self.controllerHelper getDataFetcher];
    }
    
    return _dataFetcher;
}

- (NSArray*)sortModes
{
    return @[@(ProgramSortByPublishedDateDesc), @(ProgramSortByViewDesc)];
}

- (NSString*)generateTrackingPath
{
    id<TrackingPathGenerating> parentViewController = (id<TrackingPathGenerating>)self.navController.topViewController;
    NSAssert([parentViewController conformsToProtocol:@protocol(TrackingPathGenerating) ], @"View controller must implement TrackingPathGenerating");
    
    NSString* strToView = @"";
    if (self.dispEntity) {
        strToView = [strToView stringByAppendingString:[NSString stringWithFormat:@"%@-%d-%@",NSStringFromClass([self.dispEntity class]), self.dispEntity.identifier,self.dispEntity.title]];
        
    }
    
    return [NSString stringWithFormat:@"%@/%@", [parentViewController generateTrackingPath], strToView];
}


#pragma mark - EntitymodalviewcontrollerDelegate Method

-(void)hideViewOnCompletionOfAnimation
{    
    [self.elementsView hideTheViewWithElements];
}

-(void)backButtonTappedOnSubElementsView
{
    [self.elementsView showTheViewWithElements];
}



@end
