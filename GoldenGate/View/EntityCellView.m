//
//  EntityCellView.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "EntityCellView.h"
#import "DisplayEntity.h"

#import "PGRatingView.h"
#import "LikeLabel.h"
#import "TVImageView.h"
#import "GGColor.h"
#import "UILabel+VerticalAlign.h"

@interface EntityCellView()

@property (weak, nonatomic) IBOutlet LikeLabel    *likeLabel;
@property (weak, nonatomic) IBOutlet PGRatingView *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel      *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel      *channelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel      *channelDescriptionLabel;
@property (weak, nonatomic) IBOutlet TVImageView  *channelLogoView;

@end

@implementation EntityCellView


- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {
        [self updateFromEntity:nil];
    }
    
    return self;
}

- (NSString*)publisherTextForEntity:(DisplayEntity*)entity
{
    NSString *publisherText = NSLocalizedString(@"UnknownPublisherLKey", @"");
    if (entity.publisher)
    {
        publisherText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), entity.publisher];
    }
    
    return publisherText;
}

- (NSString*)logoUrlForEntity:(DisplayEntity*)entity
{
    // Take retina resolution into account
    float pixelScale = [UIScreen mainScreen].scale;
    int wantedWidth  = self.channelLogoView.frame.size.width  * pixelScale;
    int wantedHeight = self.channelLogoView.frame.size.height * pixelScale;
    
    return [entity logoURLStringForSize:CGSizeMake(wantedWidth, wantedHeight)];
}

- (void)updateFromEntity:(DisplayEntity *)aEntity
{
    self.likeLabel.hidden           = aEntity == nil;
    self.publisherLabel.hidden      = aEntity == nil;
    self.channelTitleLabel.hidden   = aEntity == nil;
    self.videoCountLabel.hidden     = aEntity == nil;
    self.ratingLabel.hidden         = aEntity == nil;
    self.channelLogoView.hidden     = aEntity == nil;
    self.channelDescriptionLabel.hidden = aEntity == nil;
    
    if (!aEntity)
    {
        self.channelLogoView.imageURL = nil;
        return;
    }
    
    self.likeLabel.likeCount        = aEntity.likeCount;
    self.ratingLabel.rating         = aEntity.pgRating;
    self.channelTitleLabel.text     = aEntity.title;
    self.publisherLabel.text        = [self publisherTextForEntity:aEntity];
    self.channelDescriptionLabel.text = aEntity.summary;
    [self.channelDescriptionLabel alignTop];
    
    // Currently disabled by design.
    self.videoCountLabel.hidden = YES;
    
    self.channelLogoView.imageURL   = [self logoUrlForEntity:aEntity];
}

- (void)setEntity:(DisplayEntity *)aEntity
{
    _entity = aEntity;
    
    [self updateFromEntity:aEntity];
}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert(dataObject == nil || [dataObject isKindOfClass:[DisplayEntity class]], @"Dataobject must be of class DisplayEntity");
    self.entity = (DisplayEntity*)dataObject;
}

- (NSObject*)fetchDataObject
{
    return self.entity;
}

- (void)styleForLightBackground
{
    self.channelTitleLabel.textColor = [GGColor mediumGrayColor];
    self.publisherLabel.textColor    = [GGColor mediumGrayColor];
}



@end
