//
//  GridCellWrapper.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GridCellWrapper.h"

#import "CellView.h"

@interface GridCellWrapper()



@end

@implementation GridCellWrapper

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.deleteButtonIcon = [UIImage imageNamed:@"SquareX.png"];
    }
    
    return self;
}

- (void)setCellView:(CellView *)cellView
{
    // Place the delete button in the upper right corner.
    self.deleteButtonOffset = CGPointMake(cellView.frame.size.width - (self.deleteButtonIcon.size.width ), 0);
    
    _cellView = cellView;
    self.contentView = cellView;
}

- (void)setDataObject:(NSObject *)dataObject
{
    [self.cellView replaceDataObject:dataObject];
}

- (NSObject*)dataObject
{
    return [self.cellView fetchDataObject];
}

@end
