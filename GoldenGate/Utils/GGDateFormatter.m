//
//  GGDateFormatter.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGDateFormatter.h"

static GGDateFormatter *gDateFormatter;

@implementation GGDateFormatter

+ (GGDateFormatter *)sharedInstance
{
    if (gDateFormatter == nil)
    {
        gDateFormatter = [GGDateFormatter new];
    }
    
    return gDateFormatter;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.dateFormat = @"MM/dd/YY";
    }
    
    return self;
}

@end
