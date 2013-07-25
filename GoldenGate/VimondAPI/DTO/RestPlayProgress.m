//
//  RestPlayProgress.m
//  GoldenGate
//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "RestPlayProgress.h"
#import "PlayProgress.h"

static NSString *kOffsetSecondsKey = @"offsetSeconds";

@implementation RestPlayProgress

+ (NSString *)root
{
    return @"playProgress";
}

- (id)initWithJSONObject:(id)data
{
    if (!data) return nil;

    if ((self = [super init]))
    {
        self.offsetSeconds = [data objectForKey:kOffsetSecondsKey];
    }

    return self;
}

- (id)JSONObject
{
    NSDictionary*d = @{[RestPlayProgress root] : @{kOffsetSecondsKey : @([self.offsetSeconds integerValue])}};
    return d;
}

- (PlayProgress*)playProgressObject
{
    PlayProgress *progress = [PlayProgress new];
    progress.offsetSeconds = [self.offsetSeconds floatValue];
    return progress;
}

@end
