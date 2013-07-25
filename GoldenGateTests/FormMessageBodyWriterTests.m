#import <SenTestingKit/SenTestingKit.h>
#import "MediaType.h"
#import "MessageBodyWriter.h"
#import "FormMessageBodyWriter.h"

@interface FormMessageBodyWriterTests : SenTestCase
@end

@implementation FormMessageBodyWriterTests {
    id <MessageBodyWriter> writer;
}

- (void)setUp
{
    writer = [FormMessageBodyWriter new];
}

- (void)test_canWrite_dictionary_returnsYES
{
    STAssertTrue([writer canWrite:[NSDictionary class] mediaType:[MediaType form]], nil);
}

- (void)test_write_dictionary_returnsString
{
    NSData *data = [writer write:@{@"id":@123, @"name":@"the_name"} mediaType:[MediaType form]];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSSet *actualSet = [NSSet setWithArray:[string componentsSeparatedByString:@"&"]];
    NSSet *expectedSet = [NSSet setWithArray:@[@"id=123", @"name=the_name"]];
    STAssertEqualObjects(actualSet, expectedSet, nil);
}

- (void)test_write_dictionaryWithIllegalCharacters_returnsURLEscapedString
{
    NSData *data = [writer write:@{@"id":@"a&b"} mediaType:[MediaType form]];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    STAssertEqualObjects(string, @"id=a%26b", nil);
}

@end