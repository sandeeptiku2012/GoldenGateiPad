//
//  TableHeaderView.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/1/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TableHeaderView.h"

@interface TableHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;

@end

@implementation TableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:self options:nil]objectAtIndex:0];
    if ((self = [super initWithFrame:contentView.frame]))
    {
        [self addSubview:contentView];
    }
    
    return self;
}

- (void)setHeaderText:(NSString *)headerText
{
    self.headerTextLabel.text = headerText;
}

- (NSString*)headerText
{
    return self.headerTextLabel.text;
}

@end
