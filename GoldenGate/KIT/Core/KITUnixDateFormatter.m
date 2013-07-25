//
//  KITUnixDateFormatter.m
//  KIT
//
//  Created by Andreas Petrov on 5/7/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "KITUnixDateFormatter.h"

@implementation KITUnixDateFormatter

- (void)commonInit
{
    self.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    self.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"; 
}

- (id)init
{
    if ((self = [super init])) 
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) 
    {
        [self commonInit];
    }
    
    return self;
}

@end
