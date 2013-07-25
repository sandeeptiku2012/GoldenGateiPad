//
//  LoadingTableCell.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/18/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LoadingTableCell.h"

@interface LoadingTableCell()



@end

@implementation LoadingTableCell

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
    self.loadingView.style = LoadingViewStyleForLightBackground;
}

//- (id)initWithLoadingViewDelegate:(id<LoadingViewDelegate>)delegate reuseIdentifier:(NSString*)identifier
//{
//    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]))
//    {
//        LoadingView *loadingView = [[LoadingView alloc]init];
//    }
//    
//    return self;
//}

@end
