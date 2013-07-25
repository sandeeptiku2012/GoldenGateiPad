//
//  FavoritesAction.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoritesAction.h"

@implementation FavoritesAction


- (id)init
{
    if ((self = [super initWithName:NSLocalizedString(@"FavoriteVideosLKey", @"")]))
    {
        self.iconName = @"FavoriteStar.png";
    }
    
    return self;
}

- (NSUInteger)hash
{
    // By returning a fixed hash we can make sure that two FavoritesAction will always be treated as equals
    return 237452231 * 12;
}

@end
