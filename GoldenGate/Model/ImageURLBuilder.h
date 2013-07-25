//
//  ImageURLBuilder.h
//  GoldenGate
//
//  Created by Andreas Petrov on 11/6/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageURLBuilder : NSObject

typedef enum
{
    ImageURLBuilderImageTypeMain,
    ImageURLBuilderImageTypeAssetThumbnail,
    ImageURLBuilderImageTypeLogo,
    ImageURLBuilderImageTypeContentPanelSingle,
    ImageURLBuilderImageTypeContentPanelDouble
} ImageURLBuilderImageType;

- (id)initWithBaseURL:(NSString *)baseURL platformName:(NSString *)platformName;

- (NSString *)buildURLWithImagePack:(NSString *)imagePack type:(ImageURLBuilderImageType)type size:(CGSize)size;

@property (copy, nonatomic) NSString *baseURL;
@property (copy, nonatomic) NSString *platformName;

@end



