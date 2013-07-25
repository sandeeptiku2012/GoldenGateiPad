//
//  KITTimeUtils.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "KITTimeUtils.h"

@implementation KITTimeUtils


+ (void)timeUntilDate:(NSDate*)date
              daysOut:(int*)daysOut
             hoursOut:(int*)hoursOut
           minutesOut:(int*)minutesOut
           secondsOut:(int*)secondsOut
{
    NSTimeInterval totalSecs = [date timeIntervalSinceDate:[NSDate date]];
    [self convertFromSeconds:totalSecs daysOut:daysOut hoursOut:hoursOut minutesOut:minutesOut secondsOut:secondsOut];
}


+ (void)convertFromSeconds:(NSTimeInterval)totalSecs
                   daysOut:(int*)daysOut
                  hoursOut:(int*)hoursOut
                minutesOut:(int*)minutesOut
                secondsOut:(int*)secondsOut
{
    int days    = (int) totalSecs / (60 * 60 * 24);
    int hours   = ((int)totalSecs - days * 60 * 60 * 24) / (60 * 60);
    int minutes = ((int)totalSecs - days * 60 * 60 * 24 - hours * 60 * 60) / 60;
    int seconds = (int) totalSecs - days * 60 * 60 * 24 - hours * 60 * 60 - minutes * 60;
    
    *daysOut    = days;
    *hoursOut   = hours;
    *minutesOut = minutes;
    *secondsOut = seconds;
}

+ (NSString*)durationStringForDuration:(NSTimeInterval)duration
{
    int days;
    int hours;
    int minutes;
    int seconds;
    
    [KITTimeUtils convertFromSeconds:duration
                             daysOut:&days
                            hoursOut:&hours
                          minutesOut:&minutes
                          secondsOut:&seconds];
    
    NSString *durationString = nil;
    if (days > 0)
    {
        durationString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", days, hours, minutes, seconds];
    }
    else if (hours > 0)
    {
        durationString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else
    {
        durationString = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    
    return durationString;
}

@end
