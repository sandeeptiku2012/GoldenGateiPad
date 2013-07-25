//
//  TitleWithGridViewCell.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 05/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "TitleWithGridViewCell.h"
#import "Constants.h"
#import "GMGridViewLayoutStrategies.h"
#import "PageIndicatorView.h"



#define kHeightOffsetForGrid 30.0
#define kLabelPadding 10

@interface TitleWithGridViewCell ()


@property(weak, nonatomic) IBOutlet GMGridView* gridView;
@property(weak, nonatomic) IBOutlet UILabel* titleLabel;
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;
@property(weak, nonatomic) IBOutlet PageIndicatorView *pageIndicatorView;
@end



@implementation TitleWithGridViewCell
@synthesize delegate = _delegate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.pageIndicatorView setHidden:TRUE];
    [self.loadingView setDelegate:self];
    [self setUpGrid];
}

-(void)setUpGrid
{
    self.gridView.layoutStrategy                      = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    self.gridView.horizontalItemSpacing               = kHorizontalGridSpacing;
    self.gridView.verticalItemSpacing                 = kVerticalGridSpacing;
    self.gridView.centerGrid                    = NO;
    self.gridView.showsHorizontalScrollIndicator      = NO;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
}

-(GMGridView*)getGridView
{
    return _gridView;
}

-(UILabel*)getTitleLabel
{
    return _titleLabel;
}

-(LoadingView*)getLoadingView
{
    return _loadingView;
}

-(float)heightOfCellForSubCellofSize:(CellSize)cellSize viewClass:(Class)viewClass numRows:(int)numRows
{
    
    float fRet = 0;
    if (numRows>0) {
        fRet = self.gridView.frame.origin.x;
        
        CellViewFactory *cellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:viewClass];
        CellView* cellView = [cellFactory createCellView];
        
        float heightCell = cellView.frame.size.height;
        
        fRet = fRet + (kHeightOffsetForGrid*2) + (numRows*heightCell) + ((numRows-1)*self.gridView.verticalItemSpacing);
    }

    return fRet;
}

- (void)showLoadingIndicatorWithText:(NSString*)strText
{
    
    [self.loadingView startLoadingWithText:strText];
}

- (void)hideLoadingIndicator
{
    [self.loadingView endLoading];
}



- (void)showMessage:(NSString *)message 
{
    
  //  self.gridView.hidden = YES;
    [self.loadingView showMessage:message];
}

-(void)showRetryWithMessage:(NSString*)strMessage
{
    [self.loadingView showRetryWithMessage:strMessage];
}


-(void)setPageCounter:(int)numPage count:(int)numPageCount
{
    if (numPageCount>0) {
        [self layoutPageIndicators];
        [self.pageIndicatorView setHidden:NO];
        self.pageIndicatorView.currentPage = numPage;
        self.pageIndicatorView.pageCount = numPageCount;
    }else{
        [self.pageIndicatorView setHidden:YES];
    }
   
}

- (void)layoutPageIndicators
{
    [self.titleLabel sizeToFit];
    
    CGRect indicatorFrame            = self.pageIndicatorView.frame;
    indicatorFrame.origin.x          = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + kLabelPadding;
    self.pageIndicatorView.frame      = indicatorFrame;
}

#pragma mark - Loadingview Delegate calls
- (void)retryButtonWasPressedInLoadingView:(LoadingView *)loadingView
{
    [self showLoadingIndicatorWithText:NSLocalizedString(@"LoadingContentLKey", @"")];
    [self.delegate retryPressedInTitleWithViewCell:self];
    
}

@end
