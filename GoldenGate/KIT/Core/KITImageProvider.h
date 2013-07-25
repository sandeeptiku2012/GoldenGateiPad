//
//  Created by Andreas Petrov on 12/2/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class KITImageProvider;

@protocol KITImageProviderDelegate <NSObject>

-(void)imageDidFinishLoading:(KITImageProvider *)provider;
-(void)imageDidStartLoading:(KITImageProvider *)provider;

@end


@interface KITImageProvider : NSObject

+ (void)clearImageCache;

- (id)initWithImageUrl:(NSString *)anImageURL;
        
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic, readonly) NSURL *imageURL;

- (void)addDelegate:(id<KITImageProviderDelegate>)delegate;
- (void)removeDelegate:(id<KITImageProviderDelegate>)delegate;



@end