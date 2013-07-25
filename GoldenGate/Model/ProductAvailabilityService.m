//
//  ProductAvailabilityService.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/29/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "ProductAvailabilityService.h"
#import "Channel.h"
#import "VimondStore.h"
#import "Video.h"

@interface  ProductAvailabilityService()

@property (strong) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSDate *dateCacheLastUpdated;
@property (strong, nonatomic) NSArray *cachedChannels;
@property (strong, nonatomic) NSOperation *myChannelsFetchingOperation;

@end

#define kCacheValidityDurationInSeconds 120

@implementation ProductAvailabilityService

+ (ProductAvailabilityService *)sharedInstance
{
    static ProductAvailabilityService *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init
{
    if (self = [super init])
    {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)checkAvailabilityForChannelID:(NSInteger)channelID handler:(AvailabilityHandler)onComplete
{
    [self fetchCachedMyChannels:^(NSArray *channelArray, NSError *error)
    {
        BOOL channelFound = NO;
        for (Channel *cachedChannel in channelArray)
        {
            if (channelID == cachedChannel.identifier)
            {
                channelFound = YES;
                break;
            }
        }
        
        onComplete(channelFound, nil);
    }];
}

- (void)checkAvailabilityForChannel:(Channel *)channel handler:(AvailabilityHandler)onComplete
{
    [self checkAvailabilityForChannelID:channel.identifier handler:onComplete];
}

- (void)checkAvailabilityForVideo:(Video*)video handler:(AvailabilityHandler)onComplete
{
    [self checkAvailabilityForChannelID:video.channelID handler:onComplete];
}


#pragma mark - Properties

- (void)fetchCachedMyChannels:(ChannelsHandler)onComplete
{

    if (![self isCacheValid])
    {
        // If we're already fetching myChannels wait for it to finish before returning.
        if (self.myChannelsFetchingOperation != nil)
        {
            NSOperation *queuedOperation = [NSBlockOperation blockOperationWithBlock:^
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                {
                    onComplete(_cachedChannels, nil);
                }];
            }];

            [queuedOperation addDependency:self.myChannelsFetchingOperation];
            [self.operationQueue addOperation:queuedOperation];
        }
        else
        {
            self.myChannelsFetchingOperation = [NSBlockOperation blockOperationWithBlock:^
            {
                NSError *error;
                _cachedChannels = [[VimondStore sharedStore] myChannels:&error];

                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                {
                    if (!error)
                    {
                        _dateCacheLastUpdated = [NSDate date];
                        self.myChannelsFetchingOperation = nil;
                    }

                    onComplete(_cachedChannels, error);
                }];
            }];

            [self.operationQueue addOperation:self.myChannelsFetchingOperation];
        }
    }
    else
    {
        onComplete(_cachedChannels, nil);
    }
}

#pragma mark - Synchronized methods

- (BOOL)isCacheValid
{
    if (_cachedChannels == nil || _dateCacheLastUpdated == nil)
    {
        return NO;
    }
    NSDate *now = [NSDate date];
    return [now timeIntervalSinceDate:_dateCacheLastUpdated] < kCacheValidityDurationInSeconds;
}

- (NSArray *)myChannels:(NSError **)error
{
    @synchronized (self)
    {
        if (![self isCacheValid])
        {
            _cachedChannels = [[VimondStore sharedStore] myChannels:error];
            _dateCacheLastUpdated = [NSDate date];
        }
    }
    return _cachedChannels;
}

- (BOOL)hasAccessToChannelWithID:(NSUInteger)channelID error:(NSError **)error
{
    NSArray *myChannels = [self myChannels:error];
    for (Channel *myChannel in myChannels)
    {
        if (myChannel.identifier == channelID)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasAccessToVideo:(Video *)video error:(NSError **)error
{
    return [self hasAccessToChannelWithID:video.channelID error:error];
}

@end
