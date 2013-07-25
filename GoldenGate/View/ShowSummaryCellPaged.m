//
//  ShowSummaryCellPagedViewController.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowSummaryCellPaged.h"
#import "KITGridLayoutView.h"
#import "Constants.h"
#import "Show.h"
#import "ShowCellView.h"
#import "VimondStore.h"
#import "Video.h"
#import "EpisodeCellView.h"
#import "CellViewFactory.h"
#import "EntityModalViewController.h"
#import "EntityVideoPlayBackViewController.h"
#import "GGBackgroundOperationQueue.h"
#import "GMGridView.h"
#import "GridViewController.h"
#import "EpisodesForShowDataFetcher.h"
#import "GMGridViewLayoutStrategies.h"
#import "GridCellWrapper.h"

@interface ShowSummaryCellPaged ()
{
    // data fetcher for fetching episodes for shows
    EpisodesForShowDataFetcher* _episodesForShowDataFetcher;
}

@property (weak, nonatomic) IBOutlet KITGridLayoutView *gridLayoutView;

@property (strong, nonatomic) ShowCellView *showCell;
@property (strong, nonatomic) NSArray *episodeCells;
@property (strong, nonatomic) NSOperation *operation;

@property(weak, nonatomic) IBOutlet GMGridView* episodeView;
@property(strong, nonatomic) GridViewController* episodeViewGridViewController;
@property(weak, nonatomic) IBOutlet LoadingView *episodeViewLoadingView;

@end

@implementation ShowSummaryCellPaged

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [self.operation cancel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.gridLayoutView.horizontalGridSpacing   = kHorizontalGridSpacing;
    self.gridLayoutView.verticalGridSpacing     = kVerticalGridSpacing;
    self.gridLayoutView.autoResizeHorizontally = FALSE;
    
    self.episodeViewLoadingView.delegate = self;
    [self setupCellViews];
    [self updateFromShow:self.show];
}

// Create some permanent views for the show cells and initialize grid layout for video
- (void)setupCellViews
{
    self.showCell = [[ShowCellView alloc]initWithCellSize:CellSizeSmall];
    [self.showCell addTarget:self action:@selector(didPressShowCellView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gridLayoutView addSubview:self.showCell];
    
    [self initializeVideoGridView];
    
}


//Sets up the scrollable grid for showing episodes of a show
- (void)setupVideosGrid
{
    
    self.episodeView.layoutStrategy                      = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    self.episodeView.horizontalItemSpacing               = kHorizontalGridSpacing;
    self.episodeView.verticalItemSpacing                 = kVerticalGridSpacing;
    self.episodeView.centerGrid                          = NO;
    self.episodeView.showsHorizontalScrollIndicator      = NO;
    self.episodeView.minEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
}

//Initialize gridview to show episodes
-(void)initializeVideoGridView
{
    [self setupVideosGrid];
    
    //allocated data fetcher if not yet allocated.
    if (nil==_episodesForShowDataFetcher) {
        _episodesForShowDataFetcher = [EpisodesForShowDataFetcher new];
        
    }
    
    if ((nil == self.episodeViewGridViewController)&&(nil!=_episodesForShowDataFetcher)) {
        PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:_episodesForShowDataFetcher];
        dataSource.sortBy = ProgramSortByRatingCount;
        
        CellViewFactory *episodeCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[EpisodeCellView class]];
        self.episodeViewGridViewController = [[GridViewController alloc] initWithGridView:self.episodeView gridCellFactory:episodeCellFactory dataSource:dataSource];
        
    }
    
    
    self.episodeViewGridViewController.delegate = self;
    
}


//setter for show
- (void)setShow:(Show *)show
{
    _show = show;
    
    // data source reset so that existing operations are all cancelled. Being a table cell view
    // ShowSummaryCellPaged can be used to display different data as user scrolls the table. So
    // the earlier network calls have to be cancelled and flushed.
    [self.episodeViewGridViewController.dataSource resetDataSource];
    
    if (_episodesForShowDataFetcher) {
        _episodesForShowDataFetcher.sourceObject = show;
    }else{
        _episodesForShowDataFetcher = [EpisodesForShowDataFetcher new];
        _episodesForShowDataFetcher.sourceObject = show;
    }
    
    // when show is set episodes are fetched for the show
    [self updateFromShow:show];
}

- (void)updateFromShow:(Show *)show
{
    if (self.showCell == nil)
    {
        return;
    }
    
    // Cancel an old fetch operation
    [self.operation cancel];
    self.showCell.show = show;
    
    if (show == nil)
    {
        return;
    }
    
    //Reload data in video grid view
    [self reloadDataInEpisodeView:show];
    
}


-(void)reloadDataInEpisodeView:(Show *)show
{
    _episodesForShowDataFetcher.sourceObject = show;
    [self showLoadingIndicatorForEpisodeView];
    [self.episodeViewGridViewController reloadData:^{
        [self hideLoadingIndicatorForEpisodeView];
        
    } errorHandler:^(NSError *error){
        [self.episodeViewLoadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
    }];
    
}

- (void)showLoadingIndicatorForEpisodeView
{
    
    [self.episodeViewLoadingView startLoadingWithText:@""];
    
}

- (void)hideLoadingIndicatorForEpisodeView
{
    [self.episodeViewLoadingView endLoading];
}

//Callback when retry button is tapped
- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    //checks the view for which retry was clicked
    if(loadingView == self.episodeViewLoadingView)
    {
        [self reloadDataInEpisodeView:self.show];
    }
    
}

- (void)didPressShowCellView:(ShowCellView*)showCellView
{
    
    [EntityModalViewController showFromView:showCellView
                                 withEntity:showCellView.show
                               navController:self.navController];
}

- (void)didPressVideoCellView:(EpisodeCellView*)videoCellView
{
    //videoplaybackviewcontroller to display show
    [EntityVideoPlayBackViewController presentVideo:videoCellView.video
                                  fromEntity:self.show
                     withNavigationController:self.navController];
}



#pragma mark - GMGridViewController callback functions

- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    if ([gridCell.cellView isKindOfClass:[EpisodeCellView class]])
    {
        [self didPressVideoCellView:((EpisodeCellView*)[gridCell cellView])];
    }
}

@end
