//
//  PageIndicatorView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGLabel.h"

@interface PageIndicatorView : GGLabel

@property (assign, nonatomic) NSUInteger pageCount;
@property (assign, nonatomic) NSUInteger currentPage;

@end
