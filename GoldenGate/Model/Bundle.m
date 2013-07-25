//
//  Bundle.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 18/06/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "Bundle.h"
#import "VimondStore.h"
#import "ImageURLBuilder.h"

@implementation Bundle


- (NSString *)logoURLStringForSize:(CGSize)size
{
    NSAssert(size.width > 0, @"Width must be larger than 0 for valid image");
    NSAssert(size.height > 0, @"Height must be larger than 0 for valid image");
    return [[VimondStore imageURLBuilder]buildURLWithImagePack:self.imagePack type:ImageURLBuilderImageTypeLogo size:size];
}

#pragma mark - SearchResultInfoDelivering

- (NSString *)searchResultTitleText
{
    return [NSString stringWithFormat:@"%@", self.publisher];
}

- (NSString *)searchResultDetailText
{
    return self.title;
}

- (NSString *)searchResultImageURLWithSize:(CGSize)size
{
    return [self logoURLStringForSize:size];
}

@end
