//
//  FeaturedChannelCellView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FeaturedContentCellView.h"

#import "TVImageView.h"
#import "FeaturedContent.h"
#import "GGColor.h"
#import "ImageURLBuilder.h"
#import "VimondStore.h"

@interface FeaturedContentCellView ()

@property (weak, nonatomic) IBOutlet TVImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation FeaturedContentCellView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Initialization code
    }
    return self;
}

- (id)initWithCellSize:(CellSize)size
{
    if ((self = [super initWithCellSize:size subclass:[self class]]))
    {

    }

    return self;
}


- (void)updateFromFeaturedContent:(FeaturedContent*)featuredContent
{
    if (!featuredContent)
    {
        return;
    }

    [self updateContentImage];
    
    // Fall back to title if there is no specific text for the featured content
    self.textLabel.text = featuredContent.text != nil ? featuredContent.text : featuredContent.title;
}


- (void)updateContentImage
{
    //TODO: Move all pixel-scale code out to its own class since this is done thrice in the app already.
    float pixelScale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(self.contentImage.frame.size.width * pixelScale,
                             self.contentImage.frame.size.height * pixelScale);
    ImageURLBuilderImageType imageType = self.cellSize == CellSizeSmall ? ImageURLBuilderImageTypeContentPanelSingle :  ImageURLBuilderImageTypeContentPanelDouble;
    
    NSString *imageURL = [[VimondStore imageURLBuilder]buildURLWithImagePack:self.featuredContent.imagePack
                                                                        type:imageType
                                                                        size:size];
    
    if (imageURL == nil)
    {
        // Use raw image URL as a fallback.
        imageURL = self.featuredContent.imageURL;
    }
    
    self.contentImage.imageURL = imageURL;
}

- (void)setFeaturedContent:(FeaturedContent *)theFeaturedContent
{
    _featuredContent = theFeaturedContent;
    
    [self updateFromFeaturedContent:theFeaturedContent];
}

- (void)replaceDataObject:(NSObject*)dataObject
{
    NSAssert(dataObject == nil || [dataObject isKindOfClass:[FeaturedContent class]], @"Dataobject must be of class FeaturedContent");
    self.featuredContent = (FeaturedContent*)dataObject;
}

- (void)showLoadingIndicator
{
    self.spinner.color = [GGColor lightGoldColor];
    self.contentImage.alpha = 0.2;
    self.selected = YES;
    
    [self.spinner startAnimating];
}

- (void)hideLoadingIndicator
{
    self.selected = NO;
    self.contentImage.alpha = 1;
    [self.spinner stopAnimating];
}

@end
