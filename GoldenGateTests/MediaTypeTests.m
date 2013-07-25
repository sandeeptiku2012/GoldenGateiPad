#import <SenTestingKit/SenTestingKit.h>
#import "MediaType.h"

@interface MediaTypeTests : SenTestCase
@end

@implementation MediaTypeTests

#pragma mark - isCompatible

- (void)test_isCompatible_equalTypesWithDifferentCase_shouldReturnTrue
{
    MediaType *xml1 = [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"xml"];
    MediaType *xml2 = [MediaType mediaTypeWithTypeName:@"APPLICATION" subTypeName:@"XML"];
    STAssertTrue([xml1 isCompatibleWith:xml2], nil);
}

- (void)test_isCompatible_differentSubTypes_shouldReturnFalse
{
    MediaType *json = [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"json"];
    MediaType *xml = [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"xml"];
    STAssertFalse([json isCompatibleWith:xml], nil);
}

- (void)test_isCompatible_wildcard1
{
    MediaType *json = [MediaType json];
    MediaType *wildcard = [MediaType wildcard];
    STAssertTrue([json isCompatibleWith:wildcard], nil);
}

- (void)test_isCompatible_wildcard2
{
    MediaType *wildcard = [MediaType mediaTypeWithTypeName:@"*" subTypeName:@"*"];
    MediaType *json = [MediaType mediaTypeWithTypeName:@"application" subTypeName:@"json"];
    STAssertTrue([wildcard isCompatibleWith:json], nil);
}

- (void)test_isCompatible_wildcard3
{
    MediaType *textPlain = [MediaType mediaTypeWithTypeName:@"text" subTypeName:@"plain"];
    MediaType *textAny = [MediaType mediaTypeWithTypeName:@"text" subTypeName:@"*"];
    STAssertTrue([textPlain isCompatibleWith:textAny], nil);
}

#pragma mark - mediaTypeFromString

- (void)test_mediaTypeFromString_plainText
{
    MediaType *result = [MediaType mediaTypeFromString:@"text/plain"];
    STAssertEqualObjects(result.typeName, @"text", nil);
    STAssertEqualObjects(result.subTypeName, @"plain", nil);
}

- (void)test_mediaTypeFromString_plainAny
{
    MediaType *result = [MediaType mediaTypeFromString:@"text/*"];
    STAssertEqualObjects(result.typeName, @"text", nil);
    STAssertEqualObjects(result.subTypeName, @"*", nil);
}

- (void)test_mediaTypeFromString_plainTextWithParameters_shouldExtractTypeAndSubType
{
    MediaType *result = [MediaType mediaTypeFromString:@"text/plain; charset=UTF-8"];
    STAssertEqualObjects(result.typeName, @"text", nil);
    STAssertEqualObjects(result.subTypeName, @"plain", nil);
}

- (void)test_mediaTypeFromString_plainTextWithParameters_shouldHaveParameters
{
    MediaType *result = [MediaType mediaTypeFromString:@"text/plain; charset=UTF-8"];
    STAssertEqualObjects([result.parameters objectForKey:@"charset"], @"UTF-8", nil );
}

@end