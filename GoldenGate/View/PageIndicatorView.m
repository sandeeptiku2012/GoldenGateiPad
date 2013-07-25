//
//  PageIndicatorView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/3/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "PageIndicatorView.h"


@implementation PageIndicatorView

- (void)commonInit
{
    [self updateText];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)updateText
{
    if (self.pageCount > 0)
    {
        self.text = [NSString stringWithFormat:NSLocalizedString(@"PageIndicatorLKey",@""), self.currentPage + 1, self.pageCount];
    }
    else
    {
        self.text = @"";
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    [self updateText];
}

- (void)setPageCount:(NSUInteger)pageCount
{
    _pageCount = pageCount;
    [self updateText];
}

@end
