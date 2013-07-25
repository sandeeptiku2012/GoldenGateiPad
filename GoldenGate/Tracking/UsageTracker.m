//
//  Created by Andreas Petrov on 11/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "UsageTracker.h"
#import "UsageEventTemplate.h"
#import "KITAsserts.h"

@interface UsageTracker ()

@property (strong, nonatomic) NSMutableDictionary *trackerProxies;
@property (strong, nonatomic) NSMutableDictionary *eventTemplates;
@property (assign, readwrite, nonatomic) BOOL trackingActive;

@end

@implementation UsageTracker
{

}

- (id)init
{
    if ((self = [super init]))
    {
        self.trackerProxies = [NSMutableDictionary new];
        self.eventTemplates = [NSMutableDictionary new];
    }

    return self;
}

- (void)registerUsageTracker:(id<UsageTracking>)tracker withName:(NSString *)name
{
    [self.trackerProxies setObject:tracker forKey:name];
}

- (void)registerEventTemplate:(UsageEventTemplate *)template
{
    [self.eventTemplates setObject:template forKey:template.eventId];
}

- (void)trackEvent:(NSInteger)eventId eventData:(id)eventData
{
    UsageEventTemplate *templateForEvent = [self eventTemplateForIdentifier:@(eventId)];
    NSString *label = nil;
    NSNumber *value = nil;
    [self getLabel:&label value:&value fromEventData:eventData forEventTemplate:templateForEvent];
    [self trackEventWithCategory:templateForEvent.categoryName
                      withAction:templateForEvent.actionName
                       withLabel:label
                       withValue:value];
}

- (void)trackTiming:(NSInteger)eventId eventData:(id)eventData
{
    UsageEventTemplate *templateForEvent = [self eventTemplateForIdentifier:@(eventId)];
    NSString *label = nil;
    NSNumber *value = nil;
    [self getLabel:&label value:&value fromEventData:eventData forEventTemplate:templateForEvent];
    [self trackTimingWithCategory:templateForEvent.categoryName
                                    withValue:[value doubleValue]
                                     withName:templateForEvent.actionName
                                    withLabel:label];
}


- (void)getLabel:(NSString **)labelOut value:(NSNumber **)valueOut fromEventData:(id)eventData forEventTemplate:(UsageEventTemplate*)templateForEvent
{
    if (templateForEvent)
    {
        if ([eventData respondsToSelector:@selector(objectForKey:)])
        {
            NSString *labelText = [eventData objectForKey:templateForEvent.labelKey];
            NSNumber *value     = [eventData objectForKey:templateForEvent.valueKey];
            BOOL hasRequiredLabel = (templateForEvent.labelKey != nil && labelText != nil)  || templateForEvent.labelKey == nil;
            BOOL hasRequiredValue = (templateForEvent.valueKey != nil && value != nil)      || templateForEvent.valueKey == nil;

            if (!hasRequiredLabel)
            {
                NSLog(@"Event data object did not property named: %@",templateForEvent.labelKey);
            }

            if (!hasRequiredValue)
            {
                NSLog(@"Event data object did not property named: %@",templateForEvent.valueKey);
            }

            KITAssertIsKindOfClass(labelText, [NSString class]);
            if (hasRequiredLabel && hasRequiredValue)
            {
                *labelOut = labelText;
                *valueOut = value;
            }
        }
    }
    else
    {
        NSLog(@"No event tracking template found for event with ID: %@", templateForEvent.eventId);
    }
}

- (UsageEventTemplate *)eventTemplateForIdentifier:(NSNumber *)identifier
{
    return [self.eventTemplates objectForKey:identifier];
}

- (BOOL)trackView:(NSString *)viewName
{
    if (!self.trackingActive) return NO;
    
    __block BOOL success = YES;
    [self.trackerProxies enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        id<UsageTracking> tracker = obj;
        BOOL localSuccess = [tracker trackView:viewName];
        if (!localSuccess)
        {
            NSLog(@"Usage tracker %@ failed to track view", key);
        }
        success &= localSuccess;
    }];

    return success;
}

- (BOOL)trackEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label withValue:(NSNumber *)value
{
    if (!self.trackingActive) return NO;
    
    __block BOOL success = YES;
    [self.trackerProxies enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        id<UsageTracking> tracker = obj;
        BOOL localSuccess = [tracker trackEventWithCategory:category withAction:action withLabel:label withValue:value];
        if (!localSuccess)
        {
            NSLog(@"Usage tracker %@ failed to track event", key);
        }
        success &= localSuccess;
    }];

    return success;
}

- (BOOL)trackTimingWithCategory:(NSString *)category withValue:(NSTimeInterval)time withName:(NSString *)name withLabel:(NSString *)label
{
    if (!self.trackingActive) return NO;
        
    __block BOOL success = YES;
    [self.trackerProxies enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        id<UsageTracking> tracker = obj;
        BOOL localSuccess = [tracker trackTimingWithCategory:category withValue:time withName:name withLabel:label];
        if (!localSuccess)
        {
            NSLog(@"Usage tracker %@ failed to track timing", key);
        }
        success &= localSuccess;
    }];

    return success;
}

- (void)startSession
{
    self.trackingActive = YES;
    [[self.trackerProxies allValues] makeObjectsPerformSelector:@selector(startSession)];
}

- (void)endSession
{
    self.trackingActive = NO;
    [[self.trackerProxies allValues] makeObjectsPerformSelector:@selector(endSession)];
}


@end