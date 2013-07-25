//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "ViewAction.h"
#import "FilterActionFactory.h"


@implementation ViewAction
{
    NSArray *_filterActions;
}

- (NSArray *)filterActions
{
    if (_filterActions == nil)
    {
        _filterActions = [FilterActionFactory createFilterActionsForViewAction:self];
        
        
        for (NavAction *action in _filterActions)
        {
            action.parentAction = self;
        }
    }

    return _filterActions;
}


@end