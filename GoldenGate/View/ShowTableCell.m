//
//  ShowTableCell.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 11/06/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "ShowTableCell.h"
#import "ShowCellView.h"

@interface ShowTableCell()

@property (strong, nonatomic) ShowCellView *showCellView;

@end

@implementation ShowTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.showCellView = [[ShowCellView alloc]initWithCellSize:CellSizeTable];
        self.showCellView.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.showCellView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.showCellView.highlighted = selected;
}

- (void)setShow:(Show *)show
{
    _show = show;
    
    self.showCellView.show = show;
}

@end
