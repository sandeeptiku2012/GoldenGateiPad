//
//  Created by Andreas Petrov on 12/2/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//


#import "KITImageProviderFactory.h"
#import "KITImageProvider.h"

static KITImageProviderFactory *instance;

@interface KITImageProviderFactory ()

+ (KITImageProviderFactory *)sharedInstance;

@property (strong) NSCache *imageProviderCache;

@end

@implementation KITImageProviderFactory

+ (void)clearImageProviders
{
    [self sharedInstance].imageProviderCache = nil;
}

+ (KITImageProvider *)imageProviderForURL:(NSString *)urlString
{
    KITImageProviderFactory * factory = [KITImageProviderFactory sharedInstance];
    KITImageProvider *imageProviderForURL = [factory.imageProviderDict objectForKey:urlString];

    if (imageProviderForURL == nil)
    {
        imageProviderForURL = [[KITImageProvider alloc] initWithImageUrl:urlString];
        [factory.imageProviderCache setObject:imageProviderForURL forKey:urlString];
    }

    return imageProviderForURL;
}

- (NSCache*)imageProviderDict
{
    if (_imageProviderCache == nil)
    {
        _imageProviderCache = [NSCache new];
    }
    
    return _imageProviderCache;
}

+ (KITImageProviderFactory *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[KITImageProviderFactory alloc] init];
    }

    return instance;
}

@end