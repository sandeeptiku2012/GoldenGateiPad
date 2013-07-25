//
//  ProductAvailabilityService.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/29/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Channel;
@class Video;

typedef void (^AvailabilityHandler)(BOOL available, NSError *error);

//extern NSString kNotificationAvailabilityC

/*!
 Use this to check if user has bought the right to view
 video or channel. This must be called quite frequently because if user
 goes over to his/her computer and buys a new channel, he/she wants to see
 the new stuff right away.
*/
@interface ProductAvailabilityService : NSObject

+ (ProductAvailabilityService *)sharedInstance;

- (void)checkAvailabilityForChannel:(Channel *)channel handler:(AvailabilityHandler)onComplete;
- (void)checkAvailabilityForVideo:(Video*)video handler:(AvailabilityHandler)onComplete;

- (BOOL)hasAccessToChannelWithID:(NSUInteger)channelID error:(NSError **)error;
- (BOOL)hasAccessToVideo:(Video *)video error:(NSError **)error;

@end
