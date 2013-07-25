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
//  PTAdBreak.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import <AVFoundation/AVFoundation.h>

#import "PTAd.h"

/**
 * The PTAdBreak instance represents a continous sequence of ads spliced into the content
 */
@interface PTAdBreak : NSObject

/** @name Properties */
/**
 * Returns a CMTimeRange describing the start time of the break relative to the content and the duration of the break.
 */
@property (nonatomic, assign) CMTimeRange relativeRange;

/** @name Properties */
/**
 * Returns a CMTimeRange describing the absolute start time of the break (content with ads spliced) and the duration of the break.
 */
@property (nonatomic, assign) CMTimeRange range;

/** @name Properties */
/**
 * Returns an array of ads to be played within this break
 */
@property (nonatomic, readonly) NSMutableArray *ads;

/**
 * Adds a PTAd instance to the list of ads contained within the break.
 * This method is currently only to be used internally.
 */
- (void)addAd:(PTAd *)ptAd;

@end
