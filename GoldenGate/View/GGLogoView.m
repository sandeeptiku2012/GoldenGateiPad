//
//  Created by Andreas Petrov on 10/30/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "GGLogoView.h"


@implementation GGLogoView
{

}

- (UIImage*)imageToUseForFrame:(CGRect)frame
{
    BOOL useLargeImage  = frame.size.width > 100;
    NSString *imageName = useLargeImage ? @"GGLogoLarge" : @"GGLogo";
    BOOL anonymousImage = NO;
    NSString *imageVersion = anonymousImage ? @"2" : @"";
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", imageName, imageVersion]];
}

- (id)init
{
    UIImage *logoImage = [self imageToUseForFrame:CGRectNull];
    if ((self = [super initWithImage:logoImage]))
    {

    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.image = [self imageToUseForFrame:self.frame];
    }

    return self;
}

@end