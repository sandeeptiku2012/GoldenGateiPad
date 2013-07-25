//
//  ChannelCellView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ChannelCellView.h"
#import "Channel.h"

#import "PGRatingView.h"
#import "LikeLabel.h"
#import "TVImageView.h"
#import "GGColor.h"
#import "UILabel+VerticalAlign.h"

@interface ChannelCellView()

@property (weak, nonatomic) IBOutlet LikeLabel    *likeLabel;
@property (weak, nonatomic) IBOutlet PGRatingView *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel      *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel      *channelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel      *channelDescriptionLabel;
@property (weak, nonatomic) IBOutlet TVImageView  *channelLogoView;

@end

@implementation ChannelCellView


- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {
        [self updateFromChannel:nil];
    }
    
    return self;
}

- (NSString*)publisherTextForChannel:(Channel*)channel
{
    NSString *publisherText = NSLocalizedString(@"UnknownPublisherLKey", @"");
    if (channel.publisher)
    {
        publisherText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), channel.publisher];
    }

    return publisherText;
}

- (NSString*)logoUrlForChannel:(Channel*)channel
{
    // Take retina resolution into account
    float pixelScale = [UIScreen mainScreen].scale;
    int wantedWidth  = self.channelLogoView.frame.size.width  * pixelScale;
    int wantedHeight = self.channelLogoView.frame.size.height * pixelScale;
    
    return [channel logoURLStringForSize:CGSizeMake(wantedWidth, wantedHeight)];
}

- (void)updateFromChannel:(Channel *)aChannel
{
    self.likeLabel.hidden           = aChannel == nil;
    self.publisherLabel.hidden      = aChannel == nil;
    self.channelTitleLabel.hidden   = aChannel == nil;
    self.videoCountLabel.hidden     = aChannel == nil;
    self.ratingLabel.hidden         = aChannel == nil;
    self.channelLogoView.hidden     = aChannel == nil;
    self.channelDescriptionLabel.hidden = aChannel == nil;
    
    if (!aChannel)
    {
        self.channelLogoView.imageURL = nil;
        return;
    }
    
    self.likeLabel.likeCount        = aChannel.likeCount;
    self.ratingLabel.rating         = aChannel.pgRating;
    self.channelTitleLabel.text     = aChannel.title;
    self.publisherLabel.text        = [self publisherTextForChannel:aChannel];
    self.channelDescriptionLabel.text = aChannel.summary;
    [self.channelDescriptionLabel alignTop];
    
    // Currently disabled by design.
    self.videoCountLabel.hidden = YES;

    self.channelLogoView.imageURL   = [self logoUrlForChannel:aChannel];
}

- (void)setChannel:(Channel *)aChannel
{
    _channel = aChannel;

    [self updateFromChannel:aChannel];
}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert(dataObject == nil || [dataObject isKindOfClass:[Channel class]], @"Dataobject must be of class Channel");
    self.channel = (Channel*)dataObject;
}

- (NSObject*)fetchDataObject
{
    return self.channel;
}

- (void)styleForLightBackground
{
    self.channelTitleLabel.textColor = [GGColor mediumGrayColor];
    self.publisherLabel.textColor    = [GGColor mediumGrayColor];
}

@end
