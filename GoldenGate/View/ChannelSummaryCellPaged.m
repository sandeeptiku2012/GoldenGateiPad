//
//  ChannelSummaryCellPaged.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 09/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ChannelSummaryCellPaged.h"
#import "KITGridLayoutView.h"
#import "Constants.h"
#import "Channel.h"
#import "ChannelCellView.h"
#import "VimondStore.h"
#import "Video.h"
#import "VideoCellView.h"
#import "CellViewFactory.h"
#import "EntityVideoPlayBackViewController.h"
#import "EntityModalViewController.h"
#import "GGBackgroundOperationQueue.h"
#import "GMGridView.h"
#import "GridViewController.h"
#import "VideosForChannelDataFetcher.h"
#import "GMGridViewLayoutStrategies.h"
#import "GridCellWrapper.h"


@interface ChannelSummaryCellPaged ()
{
    //Satish: data fetcher for fetching videos for channels
    VideosForChannelDataFetcher* _videosForChannelDataFetcher;
}
@property (weak, nonatomic) IBOutlet KITGridLayoutView *gridLayoutView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@property (strong, nonatomic) ChannelCellView *channelCell;
@property (strong, nonatomic) NSArray *videoCells;

//@property (strong, nonatomic) NSTimer *videoCellLoadDelayTimer;
@property (strong, nonatomic) NSOperation *operation;

@property(weak, nonatomic) IBOutlet GMGridView* videoView;
@property(strong, nonatomic) GridViewController* videoViewGridViewController;
@property(weak, nonatomic) IBOutlet LoadingView *videoViewLoadingView;


@end

@implementation ChannelSummaryCellPaged

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
    
    [self setupCellViews];
    [self updateFromChannel:self.channel];
}

// Create some permanent views for the channel cells and initialize grid layout for video
- (void)setupCellViews
{
    self.channelCell = [[ChannelCellView alloc]initWithCellSize:CellSizeSmall];
    [self.channelCell addTarget:self action:@selector(didPressChannelCellView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gridLayoutView addSubview:self.channelCell];
    
    [self initializeVideoGridView];
    
}


//Satish: Sets up the scrollable grid for showing videos of a channel
- (void)setupVideosGrid
{
    
    self.videoView.layoutStrategy                      = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    self.videoView.horizontalItemSpacing               = kHorizontalGridSpacing;
    self.videoView.verticalItemSpacing                 = kVerticalGridSpacing;
    self.videoView.centerGrid                    = NO;
    self.videoView.showsHorizontalScrollIndicator      = NO;
    self.videoView.minEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);    
}

//Satish: Initialize gridview to show videos
-(void)initializeVideoGridView
{
    [self setupVideosGrid];
    
    //allocated data fetcher if not yet allocated.
    if (nil==_videosForChannelDataFetcher) {
        _videosForChannelDataFetcher = [VideosForChannelDataFetcher new];
        
    }
    
    if ((nil == self.videoViewGridViewController)&&(nil!=_videosForChannelDataFetcher)) {
        PrefetchingDataSource *dataSource = [PrefetchingDataSource createWithDataFetcher:_videosForChannelDataFetcher];
        dataSource.sortBy = ProgramSortByRatingCount;
        CellViewFactory *videoCellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[VideoCellView class]];
        self.videoViewGridViewController = [[GridViewController alloc] initWithGridView:self.videoView gridCellFactory:videoCellFactory dataSource:dataSource];
    }
    
    
    self.videoViewGridViewController.delegate = self;
    
}


//Satish: setter for channel
- (void)setChannel:(Channel *)channel
{
    _channel = channel;
    
    //data source reset so that any current operation is flushed. As being a table view cell, the same cell might be
    //used to display data of different entities
    [[self.videoViewGridViewController dataSource] resetDataSource];
    
    if (_videosForChannelDataFetcher) {
        _videosForChannelDataFetcher.sourceObject = channel;
    }else{
        _videosForChannelDataFetcher = [VideosForChannelDataFetcher new];
        _videosForChannelDataFetcher.sourceObject = channel;
    }
    
    //Satish: when channel is set videos are fetched for the channel
    [self updateFromChannel:channel];
}

- (void)updateFromChannel:(Channel *)channel
{
    if (self.channelCell == nil)
    {
        return;
    }
    
    // Cancel an old fetch operation
    [self.operation cancel];
    self.channelCell.channel = channel;
    
    if (channel == nil)
    {
        return;
    }
    
    //Satish: Reload data in video grid view
    [self reloadDataInVideoView:channel];
    
}


-(void)reloadDataInVideoView:(Channel *)channel
{
    _videosForChannelDataFetcher.sourceObject = channel;
    [self showLoadingIndicatorForVideoView];
    [self.videoViewGridViewController reloadData:^{
        [self hideLoadingIndicatorForVideoView];
        
    } errorHandler:^(NSError *error){
        [self.videoViewLoadingView showRetryWithMessage:NSLocalizedString(@"ErrorLoadingContentLKey", @"")];
    }];
}

- (void)showLoadingIndicatorForVideoView
{
    
    [self.videoViewLoadingView startLoadingWithText:@""];
    
}

- (void)hideLoadingIndicatorForVideoView
{
    [self.videoViewLoadingView endLoading];
}

//Satish: Callback when retry button is tapped
- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    //Satish: checks the view for which retry was clicked
    if(loadingView == self.videoViewLoadingView)
    {
        [self reloadDataInVideoView:self.channel];
    }
    
}

- (void)didPressChannelCellView:(ChannelCellView*)channelCellView
{
    // Modalview controlled popped up on tapping channel cell
    [EntityModalViewController showFromView:channelCellView withEntity:channelCellView.channel navController:self.navController];
}

- (void)didPressVideoCellView:(VideoCellView*)videoCellView
{
    [EntityVideoPlayBackViewController presentVideo:videoCellView.video
                                  fromEntity:self.channel
                     withNavigationController:self.navController];
}



#pragma mark - GMGridViewController callback functions

- (void)gridViewController:(GridViewController *)gridViewController didTapCell:(GridCellWrapper *)gridCell
{
    if ([gridCell.cellView isKindOfClass:[VideoCellView class]])
    {
        [self didPressVideoCellView:((VideoCellView*)[gridCell cellView])];
    }
}



@end
