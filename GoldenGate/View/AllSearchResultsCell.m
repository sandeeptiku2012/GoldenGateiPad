//
//  AllSearchResultsCell.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "AllSearchResultsCell.h"

@interface AllSearchResultsCell()

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation AllSearchResultsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)setCellText:(NSString *)cellText
{
    _cellLabel.text = cellText;
}

- (NSString*)cellText
{
    return _cellLabel.text;
}

- (void)startSpinner
{
    self.cellLabel.hidden = YES;
    [self.spinner startAnimating];
}

- (void)stopSpinner
{
    self.cellLabel.hidden = NO;
    [self.spinner stopAnimating];
}

@end
