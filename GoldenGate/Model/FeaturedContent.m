//
//  FeaturedContentInfo.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FeaturedContent.h"

@interface FeaturedContent()

//@property (strong, nonatomic)

@end

static NSDictionary *gContentTypeString;

@implementation FeaturedContent

+ (void)initialize
{
    if (gContentTypeString == nil)
    {
        gContentTypeString =
        @{
            @"category"         : @(FeaturedContentTypeCategory),
            @"main_category"    : @(FeaturedContentTypeCategory),
            @"content_category" : @(FeaturedContentTypeEntity),
            @"asset"            : @(FeaturedContentTypeAsset),
            @"productgroup"     : @(FeaturedContentTypeBundle) 
        };
    }
}

- (FeaturedContentType)contentTypeFromString:(NSString*)string
{
    FeaturedContentType type = FeaturedContentTypeUnknown;
    
    NSNumber *num = [gContentTypeString objectForKey:string];
    if (num)
    {
        type = [num intValue];
    }
    
    return type;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [super description]];
}

- (void)setContentTypeFromString:(NSString *)contentType
{
    self.contentType = [self contentTypeFromString:contentType];
}

@end
