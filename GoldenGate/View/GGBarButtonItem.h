//
//  GGBarButtonItem.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGBarButtonItem : UIBarButtonItem

- (id)initWithTitle:(NSString*)title image:(UIImage*)image target:(id)target action:(SEL)action;
-(void)setNewTitle:(NSString*)strTitle;

@end
