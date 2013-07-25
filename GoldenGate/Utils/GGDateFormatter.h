//
//  GGDateFormatter.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract
 A shared NSDateFormatter that is used for formatting the dates to show
 publication dates across the app.
 */
@interface GGDateFormatter : NSDateFormatter

+ (GGDateFormatter *)sharedInstance;

@end
