//
//  LikeBarButton.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/25/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LikeBarButton.h"
#import "LikeButton.h"

@interface LikeBarButton()

@property (strong, nonatomic) LikeButton* likeButton;

@end

@implementation LikeBarButton

- (void)commonInit
{
    self.likeButton = [[LikeButton alloc]init];
    self.customView = self.likeButton;
    
    [self.likeButton addTarget:self action:@selector(didPressLikeButton) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setLiked:(BOOL)liked
{
    _liked = liked;
    self.likeButton.selected = liked;
}

- (void)didPressLikeButton
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
}

@end
