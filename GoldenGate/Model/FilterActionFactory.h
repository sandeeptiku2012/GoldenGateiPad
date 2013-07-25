//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

@class ContentCategory;
@class ViewAction;


@interface FilterActionFactory : NSObject

+ (NSArray *)createFilterActionsForViewAction:(ViewAction*)viewAction;

@end