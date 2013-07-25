//
//  FavoriteBarButtonItem.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/27/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "FavoriteBarButtonItem.h"

#import "FavoriteButton.h"

@interface FavoriteBarButtonItem()

@property (strong, nonatomic) FavoriteButton *favoriteButton;

@end

@implementation FavoriteBarButtonItem

- (void)commonInit
{
    self.favoriteButton = [[FavoriteButton alloc]init];
    self.customView = self.favoriteButton;
    
    [self.favoriteButton addTarget:self action:@selector(didPressFavoriteButton) forControlEvents:UIControlEventTouchUpInside];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    if ((self = [super init]))
    {
        self.target = target;
        self.action = action;
        [self commonInit];
    }
    
    return self;
}

- (void)setFavorited:(BOOL)favorited
{
    _favorited = favorited;
    self.favoriteButton.selected = favorited;
}

- (void)didPressFavoriteButton
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
}

@end
