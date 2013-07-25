//
//  VideoTileView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ShowSubCellView.h"

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
#import "Channel.h"
#import "VimondStore.h"
#import "PlaybackStore.h"
#import "PlayProgress.h"
#import "Show.h"

@interface ShowSubCellView() {
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

@implementation ShowSubCellView


- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {
        [self updateFromShow:nil];
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
- (NSString*)thumbnailURLForShow:(Show*)aShow
{
    // Take retina resolution into account
    float pixelScale = [UIScreen mainScreen].scale;
    int wantedWidth  = (int)(self.videoThumbnailView.frame.size.width  * pixelScale);
    int wantedHeight = (int)(self.videoThumbnailView.frame.size.height * pixelScale);
    
    return [aShow logoURLStringForSize:CGSizeMake(wantedWidth, wantedHeight)];
    
}

//- (void)updateShowTitleFromVideo:(Video *)aVideo
//{
//    [self.updateTitleOperation cancel];
//    
//    if (self.showTitleLabel)
//    {
//        self.showTitleLabel.text = @"";
//        self.updateTitleOperation = [NSBlockOperation blockOperationWithBlock:^
//                                     {
//                                         Channel *channel = [[VimondStore channelStore] channelWithId:aVideo.channelID error:nil];
//                                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
//                                          {
//                                              self.showTitleLabel.text = channel != nil ? channel.title : @"";
//                                          }];
//                                     }];
//        
//        [[GGBackgroundOperationQueue sharedInstance] addOperation:self.updateTitleOperation];
//    }
//}

- (void)updateFromShow:(Show *)aShow
{
    self.likeLabel.hidden               = aShow == nil;
    self.dateAndDurationLabel.hidden    = aShow == nil;
    self.showTitleLabel.hidden       = aShow == nil || (aShow != nil && !self.showShowTitleLabel);
    self.videoTitleLabel.hidden         = aShow == nil;
    self.videoThumbnailView.hidden      = aShow == nil;
    self.watchPreviewBadge.hidden       = aShow == nil;
    self.badgeNew.hidden                = YES;
    
    if (!aShow)
    {
        self.videoThumbnailView.imageURL = nil;
        return;
    }
    
    self.likeLabel.likeCount            = aShow.likeCount;
    self.videoTitleLabel.text           = aShow.title; 
    self.videoThumbnailView.imageURL    = [self thumbnailURLForShow:aShow];

    self.summaryLabel.text              = aShow.summary;
    [self.summaryLabel alignTop];
    self.showTitleLabel.text = aShow.title;



}

//- (void)updateNewBadgeVisibilityFromVideo:(Video *)video
//{
//    self.badgeNew.hidden = YES;
//    self.badgeNew.alpha = 1; // reset alpha because it might have been set to 0 by fadeOutNewBadge
//    
//    NSTimeInterval secondsInAWeek = 60 * 60 * 24 * 7;
//    NSDate *aWeekAgo = [NSDate dateWithTimeIntervalSinceNow:-secondsInAWeek];
//    BOOL isVideoNew = [video.publishedDate earlierDate:aWeekAgo] == aWeekAgo;
//    
//    if (isVideoNew)
//    {
//        [[GGBackgroundOperationQueue sharedInstance]addOperationWithBlock:^
//         {
//             BOOL hasAccess = [[ProductAvailabilityService sharedInstance] hasAccessToVideo:video error:nil];
//             Video *videoToCheck = hasAccess ? video : video.previewVideo;
//             if (videoToCheck.identifier != 0)
//             {
//                 PlayProgress *progress = [[VimondStore playbackStore] playProgressForVideo:videoToCheck error:nil];
//                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
//                  {
//                      self.badgeNew.hidden = progress != nil;
//                  }];
//             }
//             else
//             {
//                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
//                  {
//                      self.badgeNew.hidden = NO;
//                  }];
//             }
//         }];
//    }
//    else
//    {
//        self.badgeNew.hidden = YES;
//    }
//}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert( dataObject == nil || [dataObject isKindOfClass:[Show class]], @"Dataobject must be of class Show");
    self.show = (Show*)dataObject;
}

- (NSObject*)fetchDataObject
{
    return self.show;
}

#pragma mark - Properties

- (void)setShow:(Show *)show
{
    _show = show;
    
    [self updateFromShow:show];
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
