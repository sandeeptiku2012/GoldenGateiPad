//
//  FavoriteBarButtonItem.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/27/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteBarButtonItem : UIBarButtonItem

@property (assign, nonatomic) BOOL favorited;

- (id)initWithTarget:(id)target action:(SEL)action;

@end
