//
//  ModalRelatedContentViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ModalRelatedContentViewController.h"
#import "ChannelsForCategoryDataFetcher.h"
#import "Channel.h"
#import "ContentCategory.h"
#import "VimondStore.h"
#import "LightBackgroundCellViewFactory.h"
#import "ChannelCellView.h"
#import "GGSegmentedControl.h"
#import "GridCellWrapper.h"
#import "GGBarButtonItem.h"
#import "ChannelsFromPublisherDataFetcher.h"
#import "ChannelModalViewController.h"

#define kFadeInDuration 0.2
#define kObjectsPrPage 16

@interface ModalRelatedContentViewController ()

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

@property (strong, nonatomic) ChannelsForCategoryDataFetcher *channelsForCategoryDataFetcher;
@property (strong, nonatomic) ChannelsFromPublisherDataFetcher *channelsFromPublisherDataFetcher;


@property (strong, nonatomic) GridViewController *gridViewController;

@property (assign, nonatomic) RelatedContentMode relatedContentMode;

@property (strong, nonatomic) NSArray *relatedContentModeStrings;
@property (strong, nonatomic) NSArray *gridHeaderLabelTextForModes;

@property (strong, nonatomic) ContentCategory *currentCategory;

@end

@implementation ModalRelatedContentViewController

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

- (id)initWithChannel:(Channel *)channel
{
    if ((self = [super init]))
    {
        _channel = channel;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridHeaderLabel.text = @""; //Remove placeholder text.
    
    self.loadingView.style = LoadingViewStyleForLightBackground;
    self.navItem.leftBarButtonItem = [[GGBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BackLKey",@"")
                                                                     image:nil
                                                                    target:self
                                                                    action:@selector(dismiss)];
    [self setupGridView];
    [self setupSegmentedControl];
    [self setupDataSources];
    [self updateFromRelatedContentMode:self.relatedContentMode];
    [self updateFromChannel:self.channel];
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
}

- (void)setupGridView
{
    self.gridView.centerGrid    = NO;
    self.gridView.clipsToBounds = YES;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(15, 5, 5, 5);
    
    LightBackgroundCellViewFactory *cellViewFactory = [[LightBackgroundCellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[ChannelCellView class]];
    self.gridViewController = [[GridViewController alloc] initWithGridView:self.gridView gridCellFactory:cellViewFactory dataSource:nil];
    self.gridViewController.delegate = self;
    self.gridViewController.clearsDataSourceOnReload = NO;
}

- (void)setupDataSources
{
    self.channelsForCategoryDataFetcher = [ChannelsForCategoryDataFetcher new];
    self.relatedByCategoryDataSource = [[PrefetchingDataSource alloc] initWithDataFetcher:self.channelsForCategoryDataFetcher];
    self.relatedByCategoryDataSource.objectsPrPage = kObjectsPrPage;
    
    self.channelsFromPublisherDataFetcher = [ChannelsFromPublisherDataFetcher new];
    self.relatedByPublisherDataSource = [[PrefetchingDataSource alloc] initWithDataFetcher:self.channelsFromPublisherDataFetcher];
    self.relatedByPublisherDataSource.objectsPrPage = kObjectsPrPage;
}

- (void)dismiss
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.dismissTarget performSelector:self.dismissSelector];
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

- (void)setChannel:(Channel *)channel
{
    _channel = channel;
    [self updateFromChannel:channel];
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

- (void)updateFromChannel:(Channel *)channel
{
    _gridHeaderLabelTextForModes = nil;
    
    [self.viewControllerOperationQueue addOperationWithBlock:^
    {
        NSError *error;
        self.currentCategory = [[VimondStore categoryStore] categoryWithId:channel.parentId error:&error];
        self.channelsForCategoryDataFetcher.sourceObject        = self.currentCategory;
        self.channelsFromPublisherDataFetcher.sourceObject      = self.channel.publisher;

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
            [NSString stringWithFormat:NSLocalizedString(@"FromPublisherLKey", @""), self.channel.publisher],
            [NSString stringWithFormat:NSLocalizedString(@"FromCategoryLKey", @""), self.currentCategory.title]
        ];
    }
    
    return _gridHeaderLabelTextForModes;
}

#pragma mark - GridViewControllerDelegate

- (void)gridViewController:(GridViewController*)gridViewController didTapCell:(GridCellWrapper*)gridCell
{
    Channel *tappedChannel = (Channel *) gridCell.cellView.fetchDataObject;
    KITAssertIsKindOfClass(tappedChannel, [Channel class]);
    
    self.channelModalViewController.channel = tappedChannel;
    [self dismiss];
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
    
    return [NSString stringWithFormat:@"%@/Related_Content_View", [parentViewController generateTrackingPath]];
}

@end
