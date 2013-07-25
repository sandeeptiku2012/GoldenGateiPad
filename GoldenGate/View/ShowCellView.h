//
//  ShowCellView.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 24/05/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"

@class Show;

@interface ShowCellView : CellView

- (id)initWithCellSize:(CellSize)size;

@property (strong, nonatomic) Show *show;
@end
