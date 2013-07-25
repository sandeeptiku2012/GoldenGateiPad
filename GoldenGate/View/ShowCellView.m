//
//  ShowCellView.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowCellView.h"
#import "Show.h"

#import "PGRatingView.h"
#import "LikeLabel.h"
#import "TVImageView.h"
#import "GGColor.h"
#import "UILabel+VerticalAlign.h"

@interface ShowCellView ()

@property (weak, nonatomic) IBOutlet LikeLabel    *likeLabel;
@property (weak, nonatomic) IBOutlet PGRatingView *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel      *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel      *showTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel      *showDescriptionLabel;
@property (weak, nonatomic) IBOutlet TVImageView  *showLogoView;

@end

@implementation ShowCellView

- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {
        [self updateFromShow:nil];
    }
    
    return self;
}

- (NSString*)publisherTextForShow:(Show*)show
{
    NSString *publisherText = NSLocalizedString(@"UnknownPublisherLKey", @"");
    if (show.publisher)
    {
        publisherText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ByLKey", @""), show.publisher];
    }
    
    return publisherText;
}

- (NSString*)logoUrlForShow:(Show*)show
{
    // Take retina resolution into account
    float pixelScale = [UIScreen mainScreen].scale;
    int wantedWidth  = self.showLogoView.frame.size.width  * pixelScale;
    int wantedHeight = self.showLogoView.frame.size.height * pixelScale;
    
    return [show logoURLStringForSize:CGSizeMake(wantedWidth, wantedHeight)];
}

- (void)updateFromShow:(Show *)aShow
{
    self.likeLabel.hidden           = aShow == nil;
    self.publisherLabel.hidden      = aShow == nil;
    self.showTitleLabel.hidden   = aShow == nil;
    self.videoCountLabel.hidden     = aShow == nil;
    self.ratingLabel.hidden         = aShow == nil;
    self.showLogoView.hidden     = aShow == nil;
    self.showDescriptionLabel.hidden = aShow == nil;
    
    if (!aShow)
    {
        self.showLogoView.imageURL = nil;
        return;
    }
    
    self.likeLabel.likeCount        = aShow.likeCount;
    self.ratingLabel.rating         = aShow.pgRating;
    self.showTitleLabel.text     = aShow.title;
    self.publisherLabel.text        = [self publisherTextForShow:aShow];
    self.showDescriptionLabel.text = aShow.summary;
    [self.showDescriptionLabel alignTop];
    
    // Currently disabled by design.
    self.videoCountLabel.hidden = YES;
    
    self.showLogoView.imageURL   = [self logoUrlForShow:aShow];
}

- (void)setShow:(Show *)aShow
{
    _show = aShow;
    
    [self updateFromShow:aShow];
}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert(dataObject == nil || [dataObject isKindOfClass:[Show class]], @"Dataobject must be of class Show");
    self.show = (Show*)dataObject;
}

- (NSObject*)fetchDataObject
{
    return self.show;
}

- (void)styleForLightBackground
{
    self.showTitleLabel.textColor = [GGColor mediumGrayColor];
    self.publisherLabel.textColor    = [GGColor mediumGrayColor];
}

@end
