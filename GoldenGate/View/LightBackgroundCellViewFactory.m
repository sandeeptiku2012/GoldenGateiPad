//
//  LightBackgroundCellViewFactory.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/29/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LightBackgroundCellViewFactory.h"

@implementation LightBackgroundCellViewFactory

- (CellView *)createCellView
{
    CellView *cellView = [super createCellView];
    [cellView styleForLightBackground];
    
    return cellView;
}

@end
