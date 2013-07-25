//
//  TVImageView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/16/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TVImageView.h"

#import "TVNoiseView.h"
#import "KITURLImageView.h"

#define kImageFadeInDuration 0.4

static NSString *ImageLoadingContext;

@interface TVImageView()

@property (strong, nonatomic) TVNoiseView *noiseView;
@property (strong, nonatomic) KITURLImageView *URLImageView;
@property (strong, nonatomic) UIActivityIndicatorView *loadSpinner;

@end

@implementation TVImageView

- (void)commonInit
{
    self.noiseView       = [TVNoiseView new];
    self.noiseView.alpha = 0.1;
    
    self.URLImageView    = [KITURLImageView new];
    self.URLImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.URLImageView.clipsToBounds = YES;
    
    [self addSubview:self.noiseView];
    [self addSubview:self.URLImageView];
    
    self.loadSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.loadSpinner.hidesWhenStopped = YES;
    
    [self addSubview:self.loadSpinner];
    
    [self.URLImageView addObserver:self forKeyPath:@"isLoadingImage" options:NSKeyValueObservingOptionOld context:&ImageLoadingContext];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)dealloc
{
    [self.URLImageView removeObserver:self forKeyPath:@"isLoadingImage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &ImageLoadingContext)
    {
        [self updateNoiseView];
    }
}

- (void)updateNoiseView
{
    BOOL showNoiseView = self.URLImageView.isLoadingImage;
    
    self.noiseView.hidden = !showNoiseView;
    
    if (showNoiseView)
    {
        [self.noiseView startAnimating];
        [self.loadSpinner startAnimating];
        self.URLImageView.alpha = 0;
    }
    else
    {
        [self.noiseView stopAnimating];
        [self.loadSpinner stopAnimating];
        [UIView animateWithDuration:kImageFadeInDuration animations:^
        {
            self.URLImageView.alpha = 1;
        }];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Have the spinner automatically center itself within the parent view.
    float xOffset = (self.frame.size.width / 2) - (self.loadSpinner.frame.size.width / 2);
    float yOffset = (self.frame.size.height / 2) - (self.loadSpinner.frame.size.height / 2);
    self.loadSpinner.frame = CGRectMake((int)xOffset,(int)yOffset, self.loadSpinner.frame.size.width, self.loadSpinner.frame.size.height);
    
    self.noiseView.frame = self.bounds;
    self.URLImageView.frame = CGRectInset(self.bounds, self.imageInset, self.imageInset);
}

#pragma mark - Properties

- (void)setImageURL:(NSString *)imageURL
{
    self.URLImageView.imageURL = imageURL;
}

- (NSString*)imageURL
{
    return self.URLImageView.imageURL;
}

@end
