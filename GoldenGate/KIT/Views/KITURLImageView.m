//
//  ImageProviderView.m
//  Created by Andreas Petrov on 12/5/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//

#import "KITURLImageView.h"
#import "KITImageProviderFactory.h"

static UIImage *gNotFoundImage;


@interface KITURLImageView ()

@property (strong, nonatomic) KITImageProvider *imageProvider;
@property (strong, nonatomic) UIActivityIndicatorView *loadSpinner;

@end

@implementation KITURLImageView

#pragma mark - Init


- (id)initWithImageURL:(NSString *)anImageURL
{
    if ((self = [super init]))
    {
        self.imageURL = anImageURL;
    }

    return self;
}

- (void)dealloc
{
    if (_imageProvider) 
    {
        [_imageProvider removeDelegate:self];
    }
}

#pragma mark - Public methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Have the spinner automatically center itself within the parent view.
    float xOffset = (self.frame.size.width / 2) - (_loadSpinner.frame.size.width / 2);
    float yOffset = (self.frame.size.height / 2) - (_loadSpinner.frame.size.height / 2);
    
    _loadSpinner.frame = CGRectMake(xOffset, yOffset, _loadSpinner.frame.size.width, _loadSpinner.frame.size.height);
}

+ (void)setNotFoundImage:(UIImage*)notFoundImage
{
    gNotFoundImage = notFoundImage;
}

#pragma mark - Properties

- (void)setImageURL:(NSString*)anImageURL
{
    _imageURL = anImageURL;
    [_imageProvider removeDelegate:self];
    
    if (_imageURL != nil)
    {
        _imageProvider = [KITImageProviderFactory imageProviderForURL:_imageURL];
        
        [_imageProvider addDelegate:self];
        
        // Call will start loading the image if it´s not loaded. Otherwise it will just set the image as expected.
        self.image = _imageProvider.image;
        if (self.image)
        {
            self.isLoadingImage = NO;
            [self.loadSpinner stopAnimating];
        }
    }
    else
    {
        self.image = nil;
    }
}

- (UIActivityIndicatorView *)loadSpinner
{
    if (_loadSpinner == nil)
    {
        _loadSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        _loadSpinner.hidesWhenStopped = YES;
        
        [self addSubview:_loadSpinner];
    }

    return _loadSpinner;
}

#pragma mark - ImageProviderDelegate

- (void)imageDidStartLoading:(KITImageProvider *)provider
{
    [self.loadSpinner startAnimating];
    self.isLoadingImage = YES;
}

- (void)imageDidFinishLoading:(KITImageProvider *)provider
{
    if ([provider.imageURL.absoluteString isEqualToString:self.imageURL])
    {
        self.image = provider.image;
        
        if (self.image == nil)
        {
            self.image = gNotFoundImage;
        }
    }

    [self.loadSpinner stopAnimating];
    self.isLoadingImage = NO;
}

@end
