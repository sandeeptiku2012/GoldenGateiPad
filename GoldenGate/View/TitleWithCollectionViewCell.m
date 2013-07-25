//
//  TitleWithCollectionViewCell.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "TitleWithCollectionViewCell.h"
#import "PageIndicatorView.h"
#import "Constants.h"

#define kHeightOffsetForCollection 30.0
#define kLabelPadding 10.0

@interface TitleWithCollectionViewCell ()

@property(weak, nonatomic) IBOutlet UICollectionView* featuredCollectionView;
@property(weak, nonatomic) IBOutlet UILabel* titleLabel;
@property(weak, nonatomic) IBOutlet LoadingView *loadingView;
@property(weak, nonatomic) IBOutlet PageIndicatorView *pageIndicatorView;

@end



@implementation TitleWithCollectionViewCell


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
    [self setUpCollectionView];
}

-(void)setUpCollectionView
{
    self.featuredCollectionView.showsHorizontalScrollIndicator      = NO;
    
}

-(UICollectionView*)getFeaturedCollectionView
{
    return _featuredCollectionView;
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
        fRet = self.featuredCollectionView.frame.origin.x;
        
        CellViewFactory *cellFactory = [[CellViewFactory alloc] initWithWantedCellSize:CellSizeSmall cellViewClass:viewClass];
        CellView* cellView = [cellFactory createCellView];
        
        float heightCell = cellView.frame.size.height;
        
        fRet = fRet  + (numRows*heightCell) + (kHeightOffsetForCollection*2);
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
    [self.delegate retryPressedInTitleWithCollectionViewCell:self];
    
}



@end
