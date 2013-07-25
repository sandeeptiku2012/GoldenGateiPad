//
//  GGBackgroundOperationQueue.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/16/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "GGBackgroundOperationQueue.h"

@interface GGBackgroundOperationQueue()

@property (strong) NSOperationQueue *queue;

@end

@implementation GGBackgroundOperationQueue

+ (NSOperationQueue *)sharedInstance
{
    static GGBackgroundOperationQueue *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance.queue;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.queue = [NSOperationQueue new];
    }
    
    return self;
}

@end
