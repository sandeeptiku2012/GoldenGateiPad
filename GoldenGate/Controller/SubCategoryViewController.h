//
//  SubCategoryViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/11/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "DoublePagedGridViewController.h"

@class ContentCategory;


/*!
 @abstract
 Shows featured content for a sub-category.
 */
@interface SubCategoryViewController : DoublePagedGridViewController

@property (strong, nonatomic) ContentCategory *category;

@end
