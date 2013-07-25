/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

//
//  PTMediaPlayerNotifications.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 8/2/12.
//

#import <Foundation/Foundation.h>

extern NSString *const PTMediaPlayerStatusNotification;
extern NSString *const PTMediaPlayerTimeChangeNotification;

extern NSString *const PTMediaPlayerItemChangedNotification;
extern NSString *const PTMediaPlayerPlayStartedNotification;
extern NSString *const PTMediaPlayerPlayCompletedNotification;
extern NSString *const PTMediaPlayerNewNotificationEntryAddedNotification;
extern NSString *const PTMediaPlayerTimelineChangedNotification;
extern NSString *const PTMediaPlayerMediaSelectionOptionsAvailableNotification;

extern NSString *const PTMediaPlayerAdBreakStartedNotification;
extern NSString *const PTMediaPlayerAdBreakCompletedNotification;
extern NSString *const PTMediaPlayerAdStartedNotification;
extern NSString *const PTMediaPlayerAdProgressNotification;
extern NSString *const PTMediaPlayerAdCompletedNotification;
extern NSString *const PTMediaPlayerAdClickNotification;

/**
 * Lists all the notifications dispatched by the MediaPlayer framework
 *
 * - *PTMediaPlayerStatusNotification*
 * - *PTMediaPlayerTimeChangeNotification*
 * - *PTMediaPlayerItemChangedNotification*
 * - *PTMediaPlayerPlayStartedNotification*
 * - *PTMediaPlayerPlayCompletedNotification*
 * - *PTMediaPlayerNewNotificationEntryAddedNotification*
 * - *PTMediaPlayerTimelineChangedNotification*
 * - *PTMediaPlayerMediaSelectionOptionsAvailableNotification*
 * - *PTMediaPlayerAdBreakStartedNotification*
 * - *PTMediaPlayerAdBreakCompletedNotification* 
 * - *PTMediaPlayerAdStartedNotification*
 * - *PTMediaPlayerAdProgressNotification*
 * - *PTMediaPlayerAdCompletedNotification*
 * - *PTMediaPlayerAdClickNotification* 
 */
@interface PTMediaPlayerNotifications : NSObject

@end
