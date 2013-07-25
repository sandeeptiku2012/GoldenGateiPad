//
//  Created by Andreas Petrov on 12/2/11.
//  Copyright (c) 2011 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class KITImageProvider;


@interface KITImageProviderFactory : NSObject

+ (KITImageProvider *)imageProviderForURL:(NSString *)urlString;
+ (void)clearImageProviders;

@end