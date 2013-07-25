//
//  CollectionCellWrapper.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 03/07/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellView;

@interface CollectionCellWrapper : UICollectionViewCell

@property (strong, nonatomic) CellView *cellView;

/*!
 @abstract stores the index this grid cell is currently inhabiting.
 */
@property (assign) NSInteger collectionIndex;
@property (assign, nonatomic) NSObject *dataObject;

@end
