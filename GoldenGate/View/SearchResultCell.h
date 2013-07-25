//
//  SearchResultCell.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (copy, nonatomic) NSString *upperLabelText;
@property (copy, nonatomic) NSString *lowerLabelText;
@property (copy, nonatomic) NSString *imageURL;

- (CGSize)imageSize;

@end
