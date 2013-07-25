//
//  CollectionViewController.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 03/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CollectionCellWrapper;
@class CellView;

@protocol CollectionViewControllerDelegate <NSObject>

@required
- (void)collectionView:(UICollectionView *)collectionView didSelectCell:(CollectionCellWrapper*)gridCell;
- (void)collectionView:(UICollectionView *)collectionView didUnselectCell:(CollectionCellWrapper*)gridCell;
- (CGSize) cellSizeForData:(NSObject*)objData;
- (CellView*) cellForData:(NSObject*)objData;

@end

@interface CollectionViewController : NSObject<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) id<CollectionViewControllerDelegate> delegate;
@property UIEdgeInsets edgeInsetForCollectionView;


/*!
 @abstract init the contrroller with view.
 */
-(id)initWithView:(UICollectionView*)collectionView;

/*!
 @abstract tells the data source to figure out how many items it has in total before making the grid view reload.
 */
- (void)reloadData:(NSArray*)arrayData;

/*!
@abstract
Will clear the datasource.
*/
- (void)clearData;
@end
