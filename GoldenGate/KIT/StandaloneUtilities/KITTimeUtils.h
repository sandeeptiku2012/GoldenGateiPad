//
//  KITTimeUtils.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KITTimeUtils : NSObject

+ (void)timeUntilDate:(NSDate*)date
              daysOut:(int*)daysOut
             hoursOut:(int*)hoursOut
           minutesOut:(int*)minutesOut
           secondsOut:(int*)secondsOut;

+ (void)convertFromSeconds:(NSTimeInterval)totalSecs
                   daysOut:(int*)daysOut
                  hoursOut:(int*)hoursOut
                minutesOut:(int*)minutesOut
                secondsOut:(int*)secondsOut;

+ (NSString*)durationStringForDuration:(NSTimeInterval)duration;

@end
