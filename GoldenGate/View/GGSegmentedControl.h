//
//  GGSegmentedControl.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/23/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSegmentedControl : UISegmentedControl

- (void)updateSegmentWidth;

@property (assign, nonatomic) BOOL usesFixedWidth;

@end
