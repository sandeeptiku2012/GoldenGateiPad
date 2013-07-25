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
//  PTAdMetadata.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 1/27/13.
//

#import <Foundation/Foundation.h>

#import "PTMetadata.h"

/**
 * The name of the key associated with this metadata type.
 * Used to retrieve the PTMetadata instance from a metadata collection.
 */
extern NSString *const PTAdResolvingMetadataKey;

/**
 * PTAdMetadata class provides properties that should be configured for resolving ads for a given media item.
 * All the required properties must be set to configure the player for successfully resolving ads.
 */
@interface PTAdMetadata : PTMetadata

/**
 * An array of CMTimeRange type values of c3 window ads.
 */
@property(nonatomic, strong) NSArray *c3AdRanges;

@end
