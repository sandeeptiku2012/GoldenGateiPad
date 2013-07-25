//
//  CollectionCellWrapper.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 03/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "CollectionCellWrapper.h"
#import "CellView.h"

@implementation CollectionCellWrapper

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setCellView:(CellView *)cellView
{
    [self.cellView removeFromSuperview];
    _cellView = cellView;
    [cellView setUserInteractionEnabled:NO];
    [self.contentView addSubview:self.cellView];
    [self setBackgroundColor:[UIColor redColor]];
}

- (void)setDataObject:(NSObject *)dataObject
{
    [self.cellView replaceDataObject:dataObject];
}

- (NSObject*)dataObject
{
    return [self.cellView fetchDataObject];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.cellView removeFromSuperview];
    _cellView = nil;
}

@end
