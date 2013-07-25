//
//  SearchResultCell.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SearchResultCell.h"

#import "KITURLImageView.h"

@interface SearchResultCell()

@property (weak ,nonatomic) IBOutlet UILabel *upperLabel;
@property (weak ,nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak ,nonatomic) IBOutlet KITURLImageView *searchResultImageView;

@end

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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

#pragma mark - Properties

- (void)setImageURL:(NSString *)imageURL
{
    self.searchResultImageView.imageURL = imageURL;
}

- (CGSize)imageSize
{
   return self.searchResultImageView.frame.size;
}


- (NSString*)imageURL
{
    return self.searchResultImageView.imageURL;
}

- (void)setUpperLabelText:(NSString *)upperLabelText
{
    self.upperLabel.text = upperLabelText;
}

- (NSString*)upperLabelText
{
    return self.upperLabel.text;
}

- (void)setLowerLabelText:(NSString *)lowerLabelText
{
    self.lowerLabel.text = lowerLabelText;
}

- (NSString*)lowerLabelText
{
    return self.lowerLabel.text;
}

@end
