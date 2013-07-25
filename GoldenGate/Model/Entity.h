//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Entity : NSObject

@property (assign, nonatomic) NSUInteger identifier;
@property (assign, nonatomic) NSUInteger parentId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *summary;

@end