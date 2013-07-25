#import "DateConverter.h"

@implementation DateConverter {
}

- (NSDate *)dateFromString:(NSString *)value
{
    NSArray *dateFormats = @[
    @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'",
    @"yyyy'-'MM'-'dd'T'HH':'mm':'ssz",
    ];
    NSDateFormatter *formatter = [NSDateFormatter new];
    for (NSString *format in dateFormats)
    {
        formatter.dateFormat = format;
        NSDate *date = [formatter dateFromString:value];
        if (date != nil)
        {
            return date;
        }
    }
    return nil;
}

@end