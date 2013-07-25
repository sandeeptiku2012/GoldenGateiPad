#import <SenTestingKit/SenTestingKit.h>
#import "DateConverter.h"

const int AllCalendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

@interface DateConverterTests : SenTestCase
@end

@implementation DateConverterTests {
}

- (void)test_dateFromString1
{
    DateConverter *converter = [DateConverter new];

    NSDate *result = [converter dateFromString:@"2012-10-22T11:25:36Z"];

    STAssertNotNil(result, nil);
    NSDateComponents *components = [[NSCalendar currentCalendar] components:AllCalendarUnits fromDate:result];
    STAssertEquals(components.year, 2012, nil);
}

- (void)test_dateFromString2
{
    DateConverter *converter = [DateConverter new];

    NSDate *result = [converter dateFromString:@"2012-10-22T11:25:36-07:00"];

    STAssertNotNil(result, nil);
    NSDateComponents *components = [[NSCalendar currentCalendar] components:AllCalendarUnits fromDate:result];
    STAssertEquals(components.year, 2012, nil);
}

@end