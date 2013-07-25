//
//  ImageURLBuilder.m
//  GoldenGate
//
//  Created by Andreas Petrov on 11/6/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ImageURLBuilder.h"
#import "UriBuilder.h"

#define kImageURLTemplate @"{baseUrl}/image/{image-pack}/{name}/customSize/{width}x{height}"


@interface ImageURLBuilder() {
    NSDictionary *_enumToTypeStringDict;
}

@property (strong, nonatomic) UriBuilder *uriBuilder;
@property (strong, nonatomic, readonly) NSDictionary *enumToTypeStringDict;

@end

@implementation ImageURLBuilder


- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName
{
    if ((self = [super init]))
    {
        _baseURL = baseURL;
        _platformName = platformName;

        self.uriBuilder = [[UriBuilder alloc] initWithTemplate:kImageURLTemplate];
    }

    return self;
}

- (NSString *)buildURLWithImagePack:(NSString *)imagePack type:(ImageURLBuilderImageType)type size:(CGSize)size
{
    if (imagePack == nil)
    {
        return nil;
    }
    
    self.uriBuilder.pathParameters =
    @{
        @"baseUrl"      : self.baseURL,
        @"image-pack"   : imagePack,
        @"name"         : [self imageTypeNameFromType:type],
        @"width"        : @(size.width),
        @"height"       : @(size.height)
    };

    return self.uriBuilder.stringValue;
}


- (NSString *)imageTypeNameFromType:(ImageURLBuilderImageType)type
{
    return [NSString stringWithFormat:[self.enumToTypeStringDict objectForKey:@(type)], self.platformName];
};

- (NSDictionary *)enumToTypeStringDict
{
    if (_enumToTypeStringDict == nil)
    {
        _enumToTypeStringDict =
        @{
            @(ImageURLBuilderImageTypeMain)                 : @"main",
            @(ImageURLBuilderImageTypeAssetThumbnail)       : @"thumb-%@",
            @(ImageURLBuilderImageTypeLogo)                 : @"channel-logo-%@",
            @(ImageURLBuilderImageTypeContentPanelSingle)   : @"banner-single-%@",
            @(ImageURLBuilderImageTypeContentPanelDouble)   : @"banner-double-%@"
        };
    }

    return _enumToTypeStringDict;
}

@end
