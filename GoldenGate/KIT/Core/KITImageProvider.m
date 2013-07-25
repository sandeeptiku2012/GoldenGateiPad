//
//  Created by Andreas Petrov on 12/2/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//

#import "KITImageProvider.h"

#define IMAGE_LOAD_TIMEOUT 10

@interface KITImageProvider ()

- (void)startLoadingImage;

@property (strong, nonatomic) NSMutableArray *imageProviderDelegates;
@property (strong, nonatomic, readwrite) NSURL *imageURL;
@property (assign, nonatomic) BOOL hasTriedToLoadURL;

@property BOOL urlContainsImageData;

@end

@implementation KITImageProvider

static NSCache *gCache;

+ (void)clearImageCache
{
    [gCache removeAllObjects];
}

+ (NSCache*)imageCache
{
    if (gCache == nil)
    {
        gCache = [[NSCache alloc]init];
    }
    
    return gCache;
}

#pragma mark - Init

- (id)initWithImageUrl:(NSString *)anImageURL
{
    self = [super init];
    
    if (self) 
    {
        self.imageURL = anImageURL.length > 0 ? [[NSURL alloc]initWithString:anImageURL] : nil;
        self.imageProviderDelegates = [[NSMutableArray alloc] init];
        self.urlContainsImageData = YES; // Assume it contains image data until otherwise proven
    }
    
    return self; 
}

#pragma mark - Public Methods

//- (void)cancelLoadingImages
//{
//    self.imageProviderDelegates = nil;
//    [self.connection cancel];
//    self.connection = nil;
//    [self unloadImages];
//
//    self.imageData = nil;
//}
//
//- (void)unloadImages
//{
//    self.imageData = nil;
//    self.image = nil;
//}

- (void)addDelegate:(id<KITImageProviderDelegate>)delegate
{
    if (![self.imageProviderDelegates containsObject:delegate])
    {
        [self.imageProviderDelegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<KITImageProviderDelegate>)delegate
{
    [self.imageProviderDelegates removeObject:delegate];
}

#pragma mark - Properties

- (UIImage *)image
{
    if (_image == nil && !self.hasTriedToLoadURL)
    {
        [self startLoadingImage];
    }

    return _image;
}

- (void)setImageURL:(NSURL *)imageURL
{
    BOOL urlChanged = ![imageURL isEqual:_imageURL];
    self.hasTriedToLoadURL = !urlChanged;
    _imageURL = imageURL;
}

#pragma mark - Private methods


- (void)imageDidLoad
{
    for (NSObject *imageProviderDelegate in self.imageProviderDelegates)
    {
        if ([imageProviderDelegate respondsToSelector:@selector(imageDidFinishLoading:)])
        {
            [imageProviderDelegate performSelector:@selector(imageDidFinishLoading:) withObject:self];
        }
    }
}

- (void)startLoadingImage
{
    self.hasTriedToLoadURL = YES;
    // Fetch image from cache if it´s already there.
    UIImage *cachedImage = [[KITImageProvider imageCache] objectForKey:_imageURL];

    if (cachedImage)
    {
        _image = cachedImage;
        [self imageDidLoad];
        return;
    }
    
    if (!self.urlContainsImageData || _imageURL == nil)
    {
        return;
    }
    
    NSMutableURLRequest * requestForImage = [NSMutableURLRequest requestWithURL:_imageURL];
    requestForImage.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    requestForImage.timeoutInterval = IMAGE_LOAD_TIMEOUT;
    [NSURLConnection sendAsynchronousRequest:requestForImage
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (!error)
        {
            _image = [UIImage imageWithData:data];
            if (_image == nil)
            {
                self.urlContainsImageData = NO;
            }
            else
            {
                [[KITImageProvider imageCache]setObject:_image forKey:_imageURL];
            }
        }
     
        [self imageDidLoad];
    }];
    
    for (NSObject *imageProviderDelegate in self.imageProviderDelegates)
    {
        if ([imageProviderDelegate respondsToSelector:@selector(imageDidStartLoading:)])
        {
            [imageProviderDelegate performSelector:@selector(imageDidStartLoading:) withObject:self];
        }
    }
}

@end
