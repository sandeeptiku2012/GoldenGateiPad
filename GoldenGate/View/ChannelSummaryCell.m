//
//  ChannelSummaryCell.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/27/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ChannelSummaryCell.h"
#import "KITGridLayoutView.h"
#import "Constants.h"
#import "Channel.h"
#import "ChannelCellView.h"
#import "VimondStore.h"
#import "Video.h"
#import "VideoCellView.h"
#import "CellViewFactory.h"
#import "VideoPlaybackViewController.h"
#import "VideoCache.h"
#import "ChannelModalViewController.h"
#import "GGBackgroundOperationQueue.h"

#define kMaxVideosPrChannel 5
#define kVideoCellRequestDelay 0.5

@interface ChannelSummaryCell()

@property (weak, nonatomic) IBOutlet KITGridLayoutView *gridLayoutView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@property (strong, nonatomic) ChannelCellView *channelCell;
@property (strong, nonatomic) NSArray *videoCells;

@property (strong, nonatomic) NSTimer *videoCellLoadDelayTimer;
@property (strong, nonatomic) NSOperation *operation;



@end

@implementation ChannelSummaryCell

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

    [self setupCellViews];
    [self updateFromChannel:self.channel];
}

// Create some permanent views for the video cells for minimum view allocation
- (void)setupCellViews
{
    self.channelCell = [[ChannelCellView alloc]initWithCellSize:CellSizeSmall];
    [self.channelCell addTarget:self action:@selector(didPressChannelCellView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gridLayoutView addSubview:self.channelCell];
    
    NSMutableArray *videoCells = [[NSMutableArray alloc] initWithCapacity:kMaxVideosPrChannel];
    CellViewFactory *cellViewFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:[VideoCellView class]];
    for (int i = 0; i < kMaxVideosPrChannel; ++i)
    {
        VideoCellView *cellView = (VideoCellView *)[cellViewFactory createCellView];
        cellView.showChannelTitleLabel = NO;
        cellView.hidden = YES;
        [cellView addTarget:self action:@selector(didPressVideoCellView:) forControlEvents:UIControlEventTouchUpInside];
        [videoCells addObject:cellView];
        [self.gridLayoutView addSubview:cellView];
    }
    
    self.videoCells = videoCells;
}

- (void)setChannel:(Channel *)channel
{
    _channel = channel;
    [self updateFromChannel:channel];
}

- (void)hideAllVideoCells
{
    for (VideoCellView *cell in self.videoCells)
    {
        cell.hidden = YES;
    }
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

    [self hideAllVideoCells];
    
    [self.videoCellLoadDelayTimer invalidate];
    [self.spinner startAnimating];

    BOOL alreadyCached = [self.videoCache areVideosForChannelCached:channel];
    if (alreadyCached)
    {
        [self updateVideoCellsFromChannel:channel];
    }
    else
    {
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:kVideoCellRequestDelay] interval:0 target:self selector:@selector(updateVideoCellsFromTimerTick:) userInfo:channel repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        // Channels where the videos are still not cached receive a little delay before trying to load them
        // This is to prevent spamming the servers when scrolling.
        self.videoCellLoadDelayTimer = timer;
    }
}

- (void)updateVideoCellsFromTimerTick:(NSTimer*)timer
{
    [self updateVideoCellsFromChannel:timer.userInfo];
}

- (void)updateVideoCellsFromChannel:(Channel*)channel
{
    // Store things in an operation so that any ongoing operations can be cancelled
    // when channel object changes.
    self.operation = [NSBlockOperation blockOperationWithBlock: ^
    {
        NSArray *videos = [self.videoCache videosForChannel:channel];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            for (NSUInteger i = 0; i < videos.count; ++i)
            {
                Video *video = [videos objectAtIndex:i];
                [self setVideoAtIndex:video atIndex:i];
            }
            [self.spinner stopAnimating];
        }];
    }];
    
    [[GGBackgroundOperationQueue sharedInstance]addOperation:self.operation];
}

- (void)setVideoAtIndex:(Video *)video atIndex:(NSUInteger)index
{
    NSAssert(index < self.videoCells.count, @"index out of bounds");
    VideoCellView *videoCellView = [self.videoCells objectAtIndex:index];
    videoCellView.hidden = NO;
    videoCellView.video = video;
}

- (void)didPressChannelCellView:(ChannelCellView*)channelCellView
{
    [ChannelModalViewController showFromView:channelCellView
                                 withChannel:channelCellView.channel
                               navController:self.navController];
}

- (void)didPressVideoCellView:(VideoCellView*)videoCellView
{
    [VideoPlaybackViewController presentVideo:videoCellView.video
                                  fromChannel:self.channel
                     withNavigationController:self.navController];
}

@end
