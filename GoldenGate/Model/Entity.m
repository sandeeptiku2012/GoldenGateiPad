//
//  Created by Andreas Petrov on 8/14/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "Entity.h"
#import "WebUtil.h"

@implementation Entity

- (NSString *)description
{
    return [NSString stringWithFormat:@"id:%d\ntitle:%@", self.identifier, self.title];
}

@end