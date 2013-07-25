//
//  TitleWithGridViewCell.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 05/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "LoadingView.h"
#import "CellView.h"
#import "CellViewFactory.h"

@protocol TitleWithGridViewCellDelegate

-(void)retryPressedInTitleWithViewCell:(id)sender;

@end

@interface TitleWithGridViewCell : UITableViewCell<LoadingViewDelegate>
{
    
}

@property(nonatomic,weak)id<TitleWithGridViewCellDelegate> delegate;
-(GMGridView*)getGridView;
-(UILabel*)getTitleLabel;
-(LoadingView*)getLoadingView;

-(void)showLoadingIndicatorWithText:(NSString*)strText;
-(void)hideLoadingIndicator;
-(void)showMessage:(NSString *)message ;
-(void)showRetryWithMessage:(NSString*)strMessage;

-(float)heightOfCellForSubCellofSize:(CellSize)cellSize viewClass:(Class)viewClass numRows:(int)numRows;

// Page counter values are set. The Label is hidden by default
// But appears when this function is called with valid values.
// When called with numPageCount 0, the label disappears again
-(void)setPageCounter:(int)numPage count:(int)numPageCount;

@end
