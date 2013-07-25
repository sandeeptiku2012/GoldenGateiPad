/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
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
//  PTTimeline.h
//  PSDKLibrary
//
//  Created by Venkat Jonnadula on 3/7/13.
//  Copyright (c) 2013 Adobe Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * PTTimeline class represents the timeline of the content (including ad breaks)
 */
@interface PTTimeline : NSObject

/** @name Properties */
/**
 * Returns an array of ad breaks (PTAdBreak) associated with this timeline
 */
@property (nonatomic, retain) NSMutableArray *adBreaks;

@end
