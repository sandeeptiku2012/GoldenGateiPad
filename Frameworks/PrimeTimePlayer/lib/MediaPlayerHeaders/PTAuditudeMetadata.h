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
//  PTAdMetadata.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import <Foundation/Foundation.h>

#import "PTAdMetadata.h"


/**
 * PTAuditudeMetadata class provides properties that should be configured for resolving auditude ads for a given media item.
 * All the required properties must be set to configure the player for successfully resolving ads.
 */
@interface PTAuditudeMetadata : PTAdMetadata

/** @name Properties */
/**
 * The domain from which ads should be fetched. The value of this property cannot be nil and must always
 * refer to a valid ad domain.
 */
@property (nonatomic, strong) NSString *domain;

/** @name Properties */
/**
 * The zoneId associated with the publisher. The value of this property must not be nil.
 */
@property (nonatomic) NSInteger zoneId;

/** @name Properties */
/**
 * A dictionary of key-values used for ad targeting. A nil value can be used if key-value targeting is not configured on the
 * publisher account.
 */
@property (nonatomic, strong) NSDictionary *targetingParameters;

@end
