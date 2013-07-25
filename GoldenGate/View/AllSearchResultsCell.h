//
//  AllSearchResultsCell.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSearchResultsCell : UITableViewCell

@property (copy, nonatomic) NSString *cellText;

- (void)startSpinner;
- (void)stopSpinner;

@end
