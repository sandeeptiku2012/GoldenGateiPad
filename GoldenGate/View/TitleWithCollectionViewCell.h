//
//  TitleWithCollectionViewCell.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "CellView.h"
#import "CellViewFactory.h"


@protocol TitleWithCollectionViewCellDelegate

-(void)retryPressedInTitleWithCollectionViewCell:(id)sender;

@end

@interface TitleWithCollectionViewCell : UITableViewCell<LoadingViewDelegate>
{
    
}


@property(nonatomic,weak) id<TitleWithCollectionViewCellDelegate> delegate;

-(UICollectionView*)getFeaturedCollectionView;
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
