//
//  EntityCellView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 10/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "CellView.h"

@class DisplayEntity;

@interface EntityCellView : CellView

- (id)initWithCellSize:(CellSize)size;

@property (strong, nonatomic) DisplayEntity *entity;

@end




