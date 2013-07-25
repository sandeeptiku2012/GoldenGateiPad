//
//  CellViewFactory.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/19/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellView.h"

@interface CellViewFactory : NSObject

@property (assign, readonly, nonatomic) CellSize wantedCellSize;
@property (strong, readonly, nonatomic) Class cellViewClass;

- (id)initWithWantedCellSize:(CellSize)wantedCellSize cellViewClass:(Class)cellViewClass;

- (CellView *)createCellView;

@end
