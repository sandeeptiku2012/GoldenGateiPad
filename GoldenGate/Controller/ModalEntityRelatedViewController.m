//
//  ModalEntityRelatedViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 17/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ModalEntityRelatedViewController.h"
#import "DisplayEntity.h"
#import "ContentCategory.h"
#import "VimondStore.h"
#import "LightBackgroundCellViewFactory.h"
#import "EntityCellView.h"
#import "GGSegmentedControl.h"
#import "GridCellWrapper.h"
#import "GGBarButtonItem.h"
#import "EntityModalViewController.h"
#import "ObjectAsSourceDataFetcher.h"
#import "EntityModalViewControllerHelper.h"
#import "EntityModalViewControllerHelperFactory.h"


#define kFadeInDuration 0.2
#define kObjectsPrPage 16

@interface ModalEntityRelatedViewController ()

typedef enum
{
    RelatedContentModeByPublisher,
    RelatedContentModeByCategory
} RelatedContentMode;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *separateNavBar;
@property (weak, nonatomic) IBOutlet UILabel *gridHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView  *contentView;
@property (weak, nonatomic) IBOutlet GMGridView *gridView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;
@property (weak, nonatomic) IBOutlet GGSegmentedControl *modeChangerSegmentedControl;

@property (strong, nonatomic) PrefetchingDataSource *relatedByCategoryDataSource;
@property (strong, nonatomic) PrefetchingDataSource *relatedByPublisherDataSource;

@property (strong, nonatomic) ObjectAsSourceDataFetcher *entityForCategoryDataFetcher;
@property (strong, nonatomic) ObjectAsSourceDataFetcher *entityFromPublisherDataFetcher;
@property (strong, nonatomic) EntityModalViewControllerHelper *entityViewControllerHelper;


@property (strong, nonatomic) GridViewController *gridViewController;

@property (assign, nonatomic) RelatedContentMode relatedContentMode;

@property (strong, nonatomic) NSArray *relatedContentModeStrings;
@property (strong, nonatomic) NSArray *gridHeaderLabelTextForModes;

@property (strong, nonatomic) ContentCategory *currentCategory;



@end

@implementation ModalEntityRelatedViewController

+ (BOOL)canDisplayRelatedViewForEntity:(Entity*)argEntity
{
    BOOL bRet = NO;
    if ([argEntity isKindOfClass:[DisplayEntity class]]) {
        bRet = YES;
    }
    
    return bRet;
}

- (id)init
{
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil])
    {
        
    }
    
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithEntity:(DisplayEntity *)entity
{
    if ((self = [super init]))
    {
        _dispEntity = entity;

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridHeaderLabel.text = @""; //Remove placeholder text.
    
    self.loadingView.style = LoadingViewStyleForLightBackground;
    self.loadingView.delegate = self;
    self.navItem.leftBarButtonItem = [[GGBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BackLKey",@"")
                                                                     image:nil
                                                                    target:self
                                                                    action:@selector(dismiss)];
    [self setupGridView];
    [self setupSegmentedControl];
    [self setupDataSources];
    [self updateFromRelatedContentMode:self.relatedContentMode];
    [self updateFromEntity:self.dispEntity];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.relatedByCategoryDataSource resetDataSource];
    [self.relatedByPublisherDataSource resetDataSource];
}

- (void)setupSegmentedControl
{
    self.modeChangerSegmentedControl.usesFixedWidth = NO;
    [self.modeChangerSegmentedControl removeAllSegments];
    [self.modeChangerSegmentedControl addTarget:self
                                         action:@selector(selectedModeChanged)
                               forControlEvents:UIControlEventValueChanged];
    
    NSArray *segmentItems = [self relatedContentModeStrings];
    [segmentItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [self.modeChangerSegmentedControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
     }];
    for (int i=0; i<[self.modeChangerSegmentedControl numberOfSegments]; i++) {
        
        NSString *title = [self.modeChangerSegmentedControl titleForSegmentAtIndex:i];
        if ([title isEqualToString:@"By same publisher"]) {
            ((UIImageView *)[[self.modeChangerSegmentedControl subviews] objectAtIndex:0]).accessibilityLabel = @"Publisher";
        }
        else if ([title isEqualToString:@"In same category"]) {
            ((UIImageView *)[[self.modeChangerSegmentedControl subviews] objectAtIndex:1]).accessibilityLabel = @"category";
        }
    }

}

- (void)setupGridView
{
    self.gridView.centerGrid    = NO;
    self.gridView.clipsToBounds = YES;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(15, 5, 5, 5);
    
    LightBackgroundCellViewFactory *cellViewFactory = [[LightBackgroundCellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EntityCellView class]];
    self.gridViewController = [[GridViewController alloc] initWithGridView:self.gridView gridCellFactory:cellViewFactory dataSource:nil];
    self.gridViewController.delegate = self;
    self.gridViewController.clearsDataSourceOnReload = NO;
}

- (void)setupDataSources
{
    self.entityForCategoryDataFetcher = [self.entityViewControllerHelper getDataFetcherForEntityofCategory];
    self.relatedByCategoryDataSource = [[PrefetchingDataSource alloc] initWithDataFetcher:self.entityForCategoryDataFetcher];
    self.relatedByCategoryDataSource.objectsPrPage = kObjectsPrPage;
    
    self.entityFromPublisherDataFetcher = [self.entityViewControllerHelper getDataFetcherForEntityofPublisher];
    self.relatedByPublisherDataSource = [[PrefetchingDataSource alloc] initWithDataFetcher:self.entityFromPublisherDataFetcher];
    self.relatedByPublisherDataSource.objectsPrPage = kObjectsPrPage;
}

- (void)dismiss
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.delegate backButtonTappedOnRelated];
#pragma clang diagnostic pop
    [self fadeOutNavBar];
}

- (void)fadeOutNavBar
{
    [UIView animateWithDuration:kFadeInDuration animations:^
     {
         self.separateNavBar.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         self.separateNavBar.hidden = YES;
     }];
}

- (void)fadeInNavBar
{
    self.separateNavBar.alpha   = 0;
    self.separateNavBar.hidden  = NO;
    [UIView animateWithDuration:kFadeInDuration animations:^
     {
         self.separateNavBar.alpha = 1;
     }];
}

- (void)setDispEntity:(DisplayEntity *)dispEntity
{
    _dispEntity = dispEntity;
    _entityViewControllerHelper = [EntityModalViewControllerHelperFactory createModalViewControllerHelperForEntity:dispEntity withNavController:self.navController];
    [self updateFromEntity:dispEntity];
}

- (void)updateFromRelatedContentMode:(RelatedContentMode)mode
{
    self.modeChangerSegmentedControl.selectedSegmentIndex = mode;
    self.gridViewController.dataSource = mode == RelatedContentModeByPublisher ? self.relatedByPublisherDataSource : self.relatedByCategoryDataSource;
}

- (void)setRelatedContentMode:(RelatedContentMode)relatedContentMode
{
    BOOL modeChanged = relatedContentMode != _relatedContentMode;
    _relatedContentMode = relatedContentMode;
    
    if (modeChanged)
    {
        [self updateFromRelatedContentMode:relatedContentMode];
    }
}

- (void)updateFromEntity:(DisplayEntity *)entity
{
    _gridHeaderLabelTextForModes = nil;
    
    [self.viewControllerOperationQueue addOperationWithBlock:^
     {
         NSError *error;
         self.currentCategory = [[VimondStore categoryStore] categoryWithId:entity.parentId error:&error];
         self.entityForCategoryDataFetcher.sourceObject        = self.currentCategory;
         self.entityFromPublisherDataFetcher.sourceObject      = self.dispEntity.publisher;
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
          {
              [self reloadGrid];
          }];
     }];
}

- (void)selectedModeChanged
{
    self.relatedContentMode = (RelatedContentMode)self.modeChangerSegmentedControl.selectedSegmentIndex;
    [self reloadGrid];
}

- (void)reloadGrid
{
    self.contentView.hidden = YES;
    [self.loadingView startLoadingWithText:NSLocalizedString(@"SearchingLKey", @"")];
    self.gridHeaderLabel.text = @"";
    [self.gridViewController reloadData:^
     {
         self.gridHeaderLabel.text = [self gridHeaderLabelTextForMode:self.relatedContentMode];
         self.contentView.hidden = NO;
         [self.loadingView endLoading];
     }
                           errorHandler:^(NSError *error)
     {
         [self.loadingView showRetryWithMessage:NSLocalizedString(@"SearchErrorLKey", @"")];
     }];
}

- (NSArray *)relatedContentModeStrings
{
    if (_relatedContentModeStrings == nil)
    {
        _relatedContentModeStrings =
        @[
        NSLocalizedString(@"RelatedBySamePublisherLKey", @""),
        NSLocalizedString(@"RelatedBySameCategoryLKey", @"")
        ];
    }
    
    return _relatedContentModeStrings;
}

- (NSString*)gridHeaderLabelTextForMode:(RelatedContentMode)mode
{
    return self.gridHeaderLabelTextForModes[mode];
}

- (NSArray *)gridHeaderLabelTextForModes
{
    if (_gridHeaderLabelTextForModes == nil)
    {
        _gridHeaderLabelTextForModes =
        @[
        [NSString stringWithFormat:NSLocalizedString(@"FromPublisherLKey", @""), [self.entityViewControllerHelper getEntityTypeString], self.dispEntity.publisher],
        [NSString stringWithFormat:NSLocalizedString(@"FromCategoryLKey", @""), [self.entityViewControllerHelper getEntityTypeString], self.currentCategory.title]
        ];
    }
    
    return _gridHeaderLabelTextForModes;
}

#pragma mark - GridViewControllerDelegate

- (void)gridViewController:(GridViewController*)gridViewController didTapCell:(GridCellWrapper*)gridCell
{
    DisplayEntity *tappedEntity = (DisplayEntity *) gridCell.cellView.fetchDataObject;
    KITAssertIsKindOfClass(tappedEntity, [DisplayEntity class]);
    
    //self.entityModalViewController.dispEntity = tappedEntity;
    [self.delegate cellOnGridTappedOnRelatedContentViewWithEntity:tappedEntity];
    //[self dismiss];
}

#pragma mark - LoadingViewDelegate

- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self reloadGrid];
}

- (NSString*)generateTrackingPath
{
    id<TrackingPathGenerating> parentViewController = (id<TrackingPathGenerating>)self.navController.topViewController;
    NSAssert([parentViewController conformsToProtocol:@protocol(TrackingPathGenerating)], @"View controller must implement TrackingPathGenerating");
    
    NSString* strToView = @"";
    if (self.dispEntity) {
        strToView = [strToView stringByAppendingString:[NSString stringWithFormat:@"%@-%d-%@",NSStringFromClass([self.dispEntity class]), self.dispEntity.identifier,self.dispEntity.title]];
        
    }
    return [NSString stringWithFormat:@"%@/Related_Content_View-%@", [parentViewController generateTrackingPath], strToView];
}
@end
