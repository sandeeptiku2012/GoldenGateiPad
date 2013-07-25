//
//  EpisodeCellView.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 27/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "EpisodeCellView.h"
#import "TVImageView.h"
#import "LikeLabel.h"
#import "Video.h"
#import "GGDateFormatter.h"
#import "KITTimeUtils.h"
#import "WatchPreviewBadge.h"
#import "UILabel+VerticalAlign.h"
#import "ProductAvailabilityService.h"
#import "FavoriteButton.h"
#import "GGBackgroundOperationQueue.h"
#import "Show.h"
#import "VimondStore.h"
#import "PlaybackStore.h"
#import "PlayProgress.h"

@interface EpisodeCellView() {
    BOOL _showShowTitleLabel;
}

@property (weak, nonatomic) IBOutlet WatchPreviewBadge  *watchPreviewBadge;
@property (weak, nonatomic) IBOutlet TVImageView  *videoThumbnailView;
@property (weak, nonatomic) IBOutlet LikeLabel    *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel      *dateAndDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel      *showTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView  *badgeNew; // Sadly Cocoa doesn't allow names starting with new

@property (weak, nonatomic) IBOutlet FavoriteButton *favoriteButton;
@property (strong, nonatomic) NSOperation *updateTitleOperation;

@end
@implementation EpisodeCellView

- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {
        [self updateFromVideo:nil];
    }
    
    return self;
}

- (NSString*)textForDateAndDurationLabel:(Video*)aVideo
{
    // Factor out from this class if this kind of label is to be displayed elsewhere.
    NSString *dateString        = aVideo.publishedDate != nil ? [[GGDateFormatter sharedInstance]stringFromDate:aVideo.publishedDate] : nil;
    NSString *durationString    = [KITTimeUtils durationStringForDuration:aVideo.duration];
    
    // Return only duration if dateString is nil
    return dateString != nil ? [NSString stringWithFormat:@"%@ - %@", dateString, durationString] : [NSString stringWithFormat:@"%@", durationString];
}

// TODO: Consolidate with ChannelCellView to avoid duplication?
- (NSString*)thumbnailURLForVideo:(Video*)aVideo
{
    // Take retina resolution into account
    float pixelScale = [UIScreen mainScreen].scale;
    int wantedWidth  = (int)(self.videoThumbnailView.frame.size.width  * pixelScale);
    int wantedHeight = (int)(self.videoThumbnailView.frame.size.height * pixelScale);
    
    return [aVideo thumbURLStringForSize:CGSizeMake(wantedWidth, wantedHeight)];
}

- (void)updateShowTitleFromVideo:(Video *)aVideo
{
    [self.updateTitleOperation cancel];
    
    if (self.showShowTitleLabel)
    {
        self.showTitleLabel.text = @"";
        self.updateTitleOperation = [NSBlockOperation blockOperationWithBlock:^
                                     {
                                         Show *show = [[VimondStore showStore] showWithId:aVideo.channelID error:nil];
                                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                          {
                                              self.showTitleLabel.text = show != nil ? show.title : @"";
                                          }];
                                     }];
        
        [[GGBackgroundOperationQueue sharedInstance] addOperation:self.updateTitleOperation];
    }
}

- (void)updateFromVideo:(Video *)aVideo
{
    self.likeLabel.hidden               = aVideo == nil;
    self.dateAndDurationLabel.hidden    = aVideo == nil;
    self.showTitleLabel.hidden       = aVideo == nil || (aVideo != nil && !self.showShowTitleLabel);
    self.videoTitleLabel.hidden         = aVideo == nil;
    self.videoThumbnailView.hidden      = aVideo == nil;
    self.watchPreviewBadge.hidden       = YES;//aVideo == nil; hiding as all videos available to all users
    self.badgeNew.hidden                = YES;
    
    if (!aVideo)
    {
        self.videoThumbnailView.imageURL = nil;
        return;
    }
    
    self.likeLabel.likeCount            = aVideo.likeCount;
    self.videoTitleLabel.text           = aVideo.title;
    self.videoThumbnailView.imageURL    = [self thumbnailURLForVideo:aVideo];
    self.dateAndDurationLabel.text      = [self textForDateAndDurationLabel:aVideo];
    self.summaryLabel.text              = aVideo.summary;
    [self.summaryLabel alignTop];
    [self updateShowTitleFromVideo:aVideo];
    [self updateNewBadgeVisibilityFromVideo:aVideo];
 
// Commenting as preview badge no longer required
//    [[ProductAvailabilityService sharedInstance]checkAvailabilityForVideo:aVideo handler:^(BOOL available, NSError *error)
//     {
//         self.watchPreviewBadge.mode = available ? WatchPreviewBadgeModeWatch : WatchPreviewBadgeModePreview;
//     }];
}

- (void)updateNewBadgeVisibilityFromVideo:(Video *)video
{
    self.badgeNew.hidden = YES;
    self.badgeNew.alpha = 1; // reset alpha because it might have been set to 0 by fadeOutNewBadge
    
    NSTimeInterval secondsInAWeek = 60 * 60 * 24 * 7;
    NSDate *aWeekAgo = [NSDate dateWithTimeIntervalSinceNow:-secondsInAWeek];
    BOOL isVideoNew = [video.publishedDate earlierDate:aWeekAgo] == aWeekAgo;
    
    if (isVideoNew)
    {
        [[GGBackgroundOperationQueue sharedInstance]addOperationWithBlock:^
         {
             BOOL hasAccess = [[ProductAvailabilityService sharedInstance] hasAccessToVideo:video error:nil];
             Video *videoToCheck = hasAccess ? video : video.previewVideo;
             if (videoToCheck.identifier != 0)
             {
                 PlayProgress *progress = [[VimondStore playbackStore] playProgressForVideo:videoToCheck error:nil];
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
                  {
                      self.badgeNew.hidden = progress != nil;
                  }];
             }
             else
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
                  {
                      self.badgeNew.hidden = NO;
                  }];
             }
         }];
    }
    else
    {
        self.badgeNew.hidden = YES;
    }
}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert( dataObject == nil || [dataObject isKindOfClass:[Video class]], @"Dataobject must be of class Video");
    self.video = (Video*)dataObject;
}

- (NSObject*)fetchDataObject
{
    return self.video;
}

#pragma mark - Properties

- (void)setVideo:(Video*)video
{
    _video = video;
    
    [self updateFromVideo:video];
}

- (void)fadeOutNewBadge
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.badgeNew.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         self.badgeNew.hidden = YES;
     }];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        [self fadeOutNewBadge];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [self fadeOutNewBadge];
    }
}

- (void)setShowShowTitleLabel:(BOOL)showShowTitleLabel
{
    _showShowTitleLabel = showShowTitleLabel;
}

- (BOOL)showShowTitleLabel
{
    return _showShowTitleLabel;
}


@end
