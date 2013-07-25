//
//  Created by Andreas Petrov on 10/24/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "FilterAction.h"


@implementation FilterAction
{

}
- (id)initWithName:(NSString *)name viewControllerClass:(Class)viewControllerClass
{
    if ((self = [super initWithName:name]))
    {
        _viewControllerClass = viewControllerClass;
        _cachable = YES;
    }

    return self;
}

- (NSUInteger)hash
{
    NSUInteger parentHash = self.parentAction.hash;
    NSString *hashBase = [NSString stringWithFormat:@"%@%@", self.name, NSStringFromClass(_viewControllerClass)];

    return hashBase.hash % parentHash;
}

@end