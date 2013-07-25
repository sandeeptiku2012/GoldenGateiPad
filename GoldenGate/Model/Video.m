//
//  Video.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/13/12.
//  Copyright (c) 2012 Andreas Petrov. All rights reserved.
//

#import "Video.h"
#import "GGDateFormatter.h"
#import "VimondStore.h"
#import "ImageURLBuilder.h"

@implementation Video

- (id)initWithId:(int)identifier
{
    if (self = [super init])
    {
        self.identifier = identifier;
    }
    return self;
}

- (NSString *)thumbURLStringForSize:(CGSize)size
{
    NSAssert(size.width > 0, @"Width must be larger than 0 for valid image");
    NSAssert(size.height > 0, @"Height must be larger than 0 for valid image");
    return [[VimondStore imageURLBuilder]buildURLWithImagePack:self.imagePack
                                                          type:ImageURLBuilderImageTypeAssetThumbnail
                                                          size:size];
}

- (Video *)previewVideo
{
    return [[Video alloc] initWithId:self.previewAssetId];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, id = %d, title = '%@', duration = %.2f sec>", [self class], self, self.identifier, self.title, self.duration];
}


#pragma mark - SearchResultInfoDelivering

- (NSString *)searchResultTitleText
{
    return [[GGDateFormatter sharedInstance]stringFromDate:self.publishedDate];
}

- (NSString *)searchResultDetailText
{
    return self.title;
}

- (NSString *)searchResultImageURLWithSize:(CGSize)size
{
    return [self thumbURLStringForSize:size];
}

@end
