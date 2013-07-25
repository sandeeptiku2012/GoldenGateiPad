//
//  RMGridLayoutView.m
//  Reaktor
//
//  Created by Andreas Petrov on 11/25/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "KITGridLayoutView.h"


@implementation KITGridLayoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.horizontalGridSpacing = 20;
        self.verticalGridSpacing = 20;
        self.autoResizeHorizontally = YES;
    }
    
    return self;
}

- (void)layoutInGrid
{
    
    UIView *lastSubview = [self.subviews lastObject];
    if (lastSubview)
    {
        // Make Offsets so that buttons are centered in the parent view.
        CGFloat xOffset = self.leftMargin;
        CGFloat yOffset = self.topMargin;
          lastSubview.accessibilityLabel=@"scrollvideo";
        UIView *subview = nil;
        
        for (int i = 0 ; i < self.subviews.count; ++i)
        {
            subview = [self.subviews objectAtIndex:i];
            
            BOOL advanceToNextRow = xOffset + subview.frame.size.width > self.frame.size.width;
            
            if (advanceToNextRow && self.autoWrap)
            {
                xOffset = self.leftMargin;
                yOffset += subview.frame.size.height + self.verticalGridSpacing;
                /*yOffset += tallestSubviewHeight + self.verticalGridSpacing;*/ // For multi height support calculate tallestSubviewHeight
            }
            
            CGFloat xOrigin = xOffset;
            CGFloat yOrigin = yOffset;
            
            // Truncate coordinates to avoid sub-pixel anti aliasing
            subview.frame = CGRectMake((int)xOrigin,(int)yOrigin, subview.frame.size.width, subview.frame.size.height);
            
            xOffset += subview.frame.size.width + self.horizontalGridSpacing;
            
            
        }
        
        CGRect frame = self.frame;
        if (self.autoResizeHorizontally) {
            
            //If autoWrap is set the horizontal width is adjusted only if new horizontal size is bigger.
            //This is because in a previous row a bigger size would already ve been set
            if (self.autoWrap) {
                if (frame.size.width<xOffset) {
                    frame.size.width = xOffset;
                }
            }else
            {
                frame.size.width = xOffset;
            }
            
        }
        
        //adjust height if the setting is autoWrap
        if (self.autoWrap) {
            frame.size.height = yOffset + subview.frame.size.height + self.verticalGridSpacing;
        }
        
        //set frame only if the new frame is different from old
        if ((self.frame.size.height!=frame.size.height)||(self.frame.size.width!=frame.size.width)||(self.frame.origin.x!=frame.origin.x)||(self.frame.origin.y!=frame.origin.y)){
            self.frame = frame;
        }
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.animateLayout)
    {
        [UIView animateWithDuration:0.5 animations:^
        {
            [self layoutInGrid];
        }];
    }
    else
    {
        [self layoutInGrid];
    }
    
}


//Function to get grid height for equal size cell
-(float)getGridHeightForEqualSizeCell:(CGSize)sizeCell numcells:(int)numCells
{
    float fRet = 0;
    
    
    if ((sizeCell.width>0)&&(numCells>0)) {
        
        float fEffContentWidth = self.frame.size.width - self.leftMargin;
        float fSpaceForTwoCells = sizeCell.width*2 + self.horizontalGridSpacing;
        int iNumCellsperRow = 0;
        if (fSpaceForTwoCells < fEffContentWidth) {
            float fEffCellWidth = sizeCell.width + self.horizontalGridSpacing;
            fEffContentWidth = fEffContentWidth - fSpaceForTwoCells;
            iNumCellsperRow = floor(fEffContentWidth/fEffCellWidth)+2;            
        }else{
            iNumCellsperRow = floor(fEffContentWidth/sizeCell.width);                       
        }
        
        
        if (iNumCellsperRow>0) {
            int iNumRows = 1;
            if (numCells>iNumCellsperRow) {
                iNumRows = ceil((float)numCells/(float)iNumCellsperRow);
            }
            
            float fSpacebetRows = self.verticalGridSpacing*iNumRows;
            float fHeightCells = iNumRows*sizeCell.height;
            fRet = self.topMargin+fHeightCells+fSpacebetRows;
        }

        
    }
    
    return fRet;
    
}



@end
