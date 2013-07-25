#import <SenTestingKit/SenTestingKit.h>
#import "StringMessageBodyReader.h"
#import "MessageBodyReader.h"
#import "MediaType.h"

@interface StringMessageBodyReaderTests : SenTestCase
@end

@implementation StringMessageBodyReaderTests
{

}

- (void)test_canReadClass
{
    id<MessageBodyReader> reader = [[StringMessageBodyReader alloc] init];
    STAssertTrue([reader canReadClass:[NSString class] mediaType:[MediaType textPlain]], nil);
}
@end