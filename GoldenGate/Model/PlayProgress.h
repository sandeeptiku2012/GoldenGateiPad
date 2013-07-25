//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>

/*!
 @abstract 
 This class stores the user's current playback progress on a given asset.
 Use this to resume playback at the number of offsetSeconds.
 */
@interface PlayProgress : NSObject

@property (assign, nonatomic) NSTimeInterval offsetSeconds;
@property (assign, nonatomic) NSInteger assetID;


@end