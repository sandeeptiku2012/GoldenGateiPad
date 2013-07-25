//
//  LikeBarButton.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/25/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeBarButton : UIBarButtonItem

@property (assign, nonatomic) BOOL liked;

- (id)initWithTarget:(id)target action:(SEL)action;

@end
