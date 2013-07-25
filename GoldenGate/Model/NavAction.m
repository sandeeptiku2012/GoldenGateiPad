//
//  NavAction.m
//  GoldenGate
//
//  Created by Andreas Petrov on 9/11/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "NavAction.h"

@interface NavAction()

@end

@implementation NavAction

- (id)init
{
    if ((self = [super init]))
    {

    }
    
    return self;
}

- (id)initWithName:(NSString *)name
{
    if ((self = [super init]))
    {
        _name = name;
    }

    return self;
}

- (NavAction*)rootAction
{
    if (self.parentAction)
    {
        return [self.parentAction rootAction];
    }
    else
    {
        return self;
    }
}

- (NSString*)name
{
    // Return localized name so that we can hide any action with the xfinity name in it.
    return NSLocalizedString(_name, @"");
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@> %p : %@", NSStringFromClass([self class]), self, self.name];
}

@end