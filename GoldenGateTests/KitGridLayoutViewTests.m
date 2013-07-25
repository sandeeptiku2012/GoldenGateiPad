//
//  KitGridLayoutViewTests.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 22/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "KitGridLayoutViewTests.h"
#import "KITGridLayoutView.h"

@implementation KitGridLayoutViewTests


-(void)test_BoundaryZeroCells
{
    KITGridLayoutView* kitLayView = [KITGridLayoutView new];
    
    CGRect frameLayout= CGRectMake(0, 0, 1024, 100);    
    [kitLayView setFrame:frameLayout];
    
    CGSize cellSize = CGSizeMake(100, 100);
    
    float height = [kitLayView getGridHeightForEqualSizeCell:cellSize numcells:0];
    

    if (0!=height) {
        STFail(@"Height is not nil");
    }
    
}

-(void)test_BoundaryZeroSize
{
    KITGridLayoutView* kitLayView = [KITGridLayoutView new];
    
    CGRect frameLayout= CGRectMake(0, 0, 1024, 100);
    [kitLayView setFrame:frameLayout];
    
    CGSize cellSize = CGSizeMake(0, 0);
    int numCells = 5;
    
    float height = [kitLayView getGridHeightForEqualSizeCell:cellSize numcells:numCells];
    
    if (0!=height) {
        STFail(@"Height is not nil");
    }
}

-(void)test_PositiveTestConditionSingleRow
{
    KITGridLayoutView* kitLayView = [KITGridLayoutView new];
    
    CGRect frameLayout= CGRectMake(0, 0, 1024, 100);
    [kitLayView setFrame:frameLayout];
    
    CGSize cellSize = CGSizeMake(100, 800);
    int numCells = 5;
    float height = [kitLayView getGridHeightForEqualSizeCell:cellSize numcells:numCells];
    
    if ((cellSize.height+kitLayView.verticalGridSpacing)!=height) {
        STFail(@"Height is not correct");
    }
}

-(void)test_PositiveTestConditionMultipleRow
{
    KITGridLayoutView* kitLayView = [KITGridLayoutView new];
    
    CGRect frameLayout= CGRectMake(0, 0, 1024, 100);
    [kitLayView setFrame:frameLayout];
    
    CGSize cellSize = CGSizeMake(100, 800);
    int numCells = 12;
    float height = [kitLayView getGridHeightForEqualSizeCell:cellSize numcells:numCells];
    
    if (((cellSize.height+kitLayView.verticalGridSpacing)*2)!=height) {
        STFail(@"Height is not correct");
    }
}

@end
