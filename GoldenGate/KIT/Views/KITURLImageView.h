//
//  ImageProviderView.h
//  chill
//
//  Created by Andreas Petrov on 12/5/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KITImageProvider.h"

@interface KITURLImageView : UIImageView <KITImageProviderDelegate>

- (id)initWithImageURL:(NSString *)anImageURL;

@property (copy, nonatomic) NSString* imageURL;
@property (assign, nonatomic) BOOL isLoadingImage;

+ (void)setNotFoundImage:(UIImage*)notFoundImage;

@end
