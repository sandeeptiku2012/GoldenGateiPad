#import <SenTestingKit/SenTestingKit.h>
#import "RestAssetRating.h"
#import "WebUtil.h"
#import "RestEntity.h"
#import "RestLoginResult.h"
#import "RestSearchAsset.h"
#import "RestMetadata.h"
#import "RestPlayback.h"

@interface JSONSerializerTests : SenTestCase
@end

@implementation JSONSerializerTests

- (void)testSerializeRestAssetRating
{
    RestAssetRating *rating = [[RestAssetRating alloc] init];
    rating.userId = @"12345";
    rating.rating = @"RATING_5";
    rating.crumb = @"12345";

    NSDictionary *result = [rating JSONObject];
    // DLog(@"result: %@", result);
    STAssertEqualObjects( [result objectForKeyPath:@"rating.userId"], @"12345", nil);
    STAssertEqualObjects( [result objectForKeyPath:@"rating.rating"], @"RATING_5", nil);
    STAssertEqualObjects( [result objectForKeyPath:@"rating.crumb"], @"12345", nil);
}

- (void)testDeserializeRestEntity
{
    NSDictionary *data = @{@"random-name":@{@"@id":@"100"}};
    // DLog(@"data: %@", data);
    RestEntity *entity = [[RestEntity alloc] initWithJSONObject:data];
    STAssertEqualObjects([NSNumber numberWithLong:100], entity.identifier, nil);
}

- (void)test_RestLoginResult_authenticated_userIdShouldParsed
{
    id object = @{@"code":@"SESSION_AUTHENTICATED", @"description":@"Authenticated session", @"reference":@"fGKAsnRw3uunbZ6UFot16upVLyprtSXRKebD5", @"userId":@1791838};

    RestLoginResult *result = [[RestLoginResult alloc] initWithJSONObject:object];

    STAssertTrue([result.userId isKindOfClass:[NSNumber class]], nil);
    STAssertEqualObjects(result.userId, @1791838, nil );
}

- (void)test_RestLoginResult_notAuthenticated_userIdShouldBeNil
{
    id object = @{@"response":@{@"code":@"SESSION_NOT_AUTHENTICATED", @"description":@"Session is not authenticated", @"reference":@"7CISvEySVAeWWBMxGBPTtlkpPmTaM3mr"}};

    RestLoginResult *result = [[RestLoginResult alloc] initWithJSONObject:object];

    STAssertNil(result.userId, nil);
}

- (void)test_RestAsset
{
    NSDictionary *metadata = @{
    @"@uri":@"/api/metadata/asset/2177785",
    @"publisher":@{@"@xml:lang":@"*", @"$":@"Norcal Publishing"},
    @"title":@{@"@xml:lang":@"en_US", @"$":@"Kerry Washington"},
    @"description-short":@{@"@xml:lang":@"en_US", @"$":@"Kerry Washington talks about the movie and how she enjoyed while working for the movie."},
    @"publisher-id":@{@"@xml:lang":@"*", @"$":@"23"},
    @"preview-asset-id":@{@"@xml:lang":@"*", @"$":@"2177786"}
    };

    id data = @{
    @"@id":@"2177785", @"@channelId":@"0", @"@categoryId":@"20111287", @"updateTime":@"2012-10-04T00:31:05Z",
    @"copyLiveStream":@NO, @"duration":@27, @"encoderGroupId":@0, @"archive":@YES,
    @"category":@{@"@uri":@"/api/iptv/category/20111287"}, @"drmProtected":@NO, @"title":@"Kerry Washington",
    @"@uri":@"/api/iptv/asset/2177785", @"views":@0, @"distributed":@1, @"deleted":@NO, @"live":@NO,
    @"playback":@{@"@uri":@"/api/iptv/asset/2177785/play"}, @"assetTypeId":@0,
    @"liveBroadcastTime":@"2012-10-03T23:36:01Z", @"metadata":metadata,
    @"product":@{@"@uri":@"/api/iptv/asset/2177785/productgroups"},
    @"description":@"Kerry Washington talks about the movie and how she enjoyed while working for the movie.",
    @"aspect16x9":@YES, @"onDemandTimeEnd":@0, @"autoEncode":@NO, @"itemsPublished":@NO, @"createTime":@"2012-10-03T23:36:01Z",
    @"imageVersions":@{@"image":@{@"url":@"http://projecthelen.net/api/image/506cd8c56c4460d0b5d5cda7/main", @"@type":@"original"}},
    @"onDemandTimeBegin":@0, @"items":@{@"@uri":@"/api/iptv/asset/2177785/items"},
    @"imageUrl":@"http://projecthelen.net/api/image/506cd8c56c4460d0b5d5cda7/main", @"autoPublish":@YES, @"encoderProfileId":@0
    };
    RestAsset *result = [[RestAsset alloc] initWithJSONObject:data];

    STAssertEqualObjects(result.identifier, @2177785, nil);
    STAssertEqualObjects(result.categoryID, @20111287, nil);
    STAssertEqualObjects(result.duration, @27, nil);
}

- (void)test_objectForKey_multipleLanguages_shouldReturnFirstItem
{
    NSString *secondTitle = @"Second Title";
    id data = @{@"title": @[
        @{@"@xml:lang": @"en_US", @"$": @"First Title"},
        @{@"@xml:lang": @"*", @"$": secondTitle}
    ]};
    
    RestMetadata *metadata = [[RestMetadata alloc] initWithJSONObject: data];
    
    id result = [metadata objectForKey: @"title"];
    
    STAssertEqualObjects(result, secondTitle, nil);
}


- (void)test_restPlayback_innerArray
{
    id data = @{
    @"playback":@{
    @"@assetId":@"2177642", @"title":@"Technology behind Avatar", @"live":@NO, @"aspect16x9":@YES, @"drmProtected":@NO, @"playbackStatus":@"OK", @"hasItems":@NO, @"liveBroadcastTime":@"2012-08-22T18:11:51Z",
    @"items":@{
    @"item":@[
    @{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554246/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-08-22/1345659250763_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554246},
    @{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554784/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-09-04/1346806564247_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554784}
    ]
    },
    @"logData":@"F59A0E62B5A62ACEE28DCCEB82F9BF361F4F9F3F574F2D9D4AC08C96E56687082E96FCA402173C8B88BC8EC84D6EC7B6418394B4327304332EA736FAC979F5543EDB1471B712437ADD2F39F7A22E0C4A4F54975CCB3A101D9C644582D9D345612D07F57687EED00BAF61A78EAB5C35FEE953A7D290ABF3116E91803E72871CF03BEB743A0455D23D2152BEFEDBEFFFD065F7126B4A0FBD6B84E96F7D95FC2EB13A83C2463B4E7A7C5BDF6A09DAFB6547EB995D3150AE4B4E8A6A0DB1B70636676DC2FFD6BF18E935B24C4445CD92E4CDB9028955A90B0B56D3232E0F30C2D89FDAB49C173B7E5182B5C4129510A021AE5FDCF2EEF5D0E0D7F0F6FEAC1C9458FF7E986B1BB694D2A1405AFA2ED07B43A48FDD390AC768A25DD8610070728E97FE34D0C056CACA42107ADB8A7549087371C1A3D54ABF59510AAE0CF4331E422D1B9389FB095DA64C0F5BB8E2A607C46763"
    }
    };
    RestPlayback *playback = [[RestPlayback alloc] initWithJSONObject:[data objectForKey:[RestPlayback root]]];
    STAssertNotNil(playback, nil);
    STAssertEquals(playback.items.count, (NSUInteger) 2, nil);
}

- (void)test_restPlayback_outerArray
{
    id data = @{
    @"playback":@{
    @"@assetId":@"2177642", @"title":@"Technology behind Avatar", @"live":@NO, @"aspect16x9":@YES, @"drmProtected":@NO, @"playbackStatus":@"OK", @"hasItems":@NO, @"liveBroadcastTime":@"2012-08-22T18:11:51Z",
    @"items":@[
    @{@"item":@{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554246/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-08-22/1345659250763_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554246}},
    @{@"item":@{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554784/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-09-04/1346806564247_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554784}}
    ],
    @"logData":@"F59A0E62B5A62ACEE28DCCEB82F9BF361F4F9F3F574F2D9D4AC08C96E56687082E96FCA402173C8B88BC8EC84D6EC7B6418394B4327304332EA736FAC979F5543EDB1471B712437ADD2F39F7A22E0C4A4F54975CCB3A101D9C644582D9D345612D07F57687EED00BAF61A78EAB5C35FEE953A7D290ABF3116E91803E72871CF03BEB743A0455D23D2152BEFEDBEFFFD065F7126B4A0FBD6B84E96F7D95FC2EB13A83C2463B4E7A7C5BDF6A09DAFB6547EB995D3150AE4B4E8A6A0DB1B70636676DC2FFD6BF18E935B24C4445CD92E4CDB9028955A90B0B56D3232E0F30C2D89FDAB49C173B7E5182B5C4129510A021AE5FDCF2EEF5D0E0D7F0F6FEAC1C9458FF7E986B1BB694D2A1405AFA2ED07B43A48FDD390AC768A25DD8610070728E97FE34D0C056CACA42107ADB8A7549087371C1A3D54ABF59510AAE0CF4331E422D1B9389FB095DA64C0F5BB8E2A607C46763"
    }
    };
    RestPlayback *playback = [[RestPlayback alloc] initWithJSONObject:[data objectForKey:[RestPlayback root]]];
    STAssertNotNil(playback, nil);
    STAssertEquals(playback.items.count, (NSUInteger) 2, nil);
}

- (void)test_restPlayback_singleItem
{
    id data = @{
    @"playback":@{
    @"@assetId":@"2177642", @"title":@"Technology behind Avatar", @"live":@NO, @"aspect16x9":@YES, @"drmProtected":@NO, @"playbackStatus":@"OK", @"hasItems":@NO, @"liveBroadcastTime":@"2012-08-22T18:11:51Z",
    @"items":
    @{@"item":@{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554784/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-09-04/1346806564247_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554784}},
    @"logData":@"F59A0E62B5A62ACEE28DCCEB82F9BF361F4F9F3F574F2D9D4AC08C96E56687082E96FCA402173C8B88BC8EC84D6EC7B6418394B4327304332EA736FAC979F5543EDB1471B712437ADD2F39F7A22E0C4A4F54975CCB3A101D9C644582D9D345612D07F57687EED00BAF61A78EAB5C35FEE953A7D290ABF3116E91803E72871CF03BEB743A0455D23D2152BEFEDBEFFFD065F7126B4A0FBD6B84E96F7D95FC2EB13A83C2463B4E7A7C5BDF6A09DAFB6547EB995D3150AE4B4E8A6A0DB1B70636676DC2FFD6BF18E935B24C4445CD92E4CDB9028955A90B0B56D3232E0F30C2D89FDAB49C173B7E5182B5C4129510A021AE5FDCF2EEF5D0E0D7F0F6FEAC1C9458FF7E986B1BB694D2A1405AFA2ED07B43A48FDD390AC768A25DD8610070728E97FE34D0C056CACA42107ADB8A7549087371C1A3D54ABF59510AAE0CF4331E422D1B9389FB095DA64C0F5BB8E2A607C46763"
    }
    };
    RestPlayback *playback = [[RestPlayback alloc] initWithJSONObject:[data objectForKey:[RestPlayback root]]];
    STAssertNotNil(playback, nil);
    STAssertEquals(playback.items.count, (NSUInteger) 1, nil);
}

- (void)test_restPlayback_doubleArray
{
    id data = @{
    @"playback":@{
    @"@assetId":@"2177642", @"title":@"Technology behind Avatar", @"live":@NO, @"aspect16x9":@YES, @"drmProtected":@NO, @"playbackStatus":@"OK", @"hasItems":@NO, @"liveBroadcastTime":@"2012-08-22T18:11:51Z",
    @"items":@[
    @{@"item":@[@{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554246/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-08-22/1345659250763_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554246}]},
    @{@"item":@[@{@"log":@{@"@uri":@"/api/iptv/asset/2177642/play/log/2554784/"}, @"bitrate":@0, @"mediaFormat":@"ismhls", @"scheme":@"http", @"server":@"www2.projecthelen.net", @"base":@"http://www2.projecthelen.net/video", @"url":@"http://www2.projecthelen.net/video//2012-09-04/1346806564247_Avatar___C(2177642_R21ISM)-m3u8-aapl.ism/Manifest(format=m3u8-aapl).m3u8", @"fileId":@2554784}]}
    ],
    @"logData":@"F59A0E62B5A62ACEE28DCCEB82F9BF361F4F9F3F574F2D9D4AC08C96E56687082E96FCA402173C8B88BC8EC84D6EC7B6418394B4327304332EA736FAC979F5543EDB1471B712437ADD2F39F7A22E0C4A4F54975CCB3A101D9C644582D9D345612D07F57687EED00BAF61A78EAB5C35FEE953A7D290ABF3116E91803E72871CF03BEB743A0455D23D2152BEFEDBEFFFD065F7126B4A0FBD6B84E96F7D95FC2EB13A83C2463B4E7A7C5BDF6A09DAFB6547EB995D3150AE4B4E8A6A0DB1B70636676DC2FFD6BF18E935B24C4445CD92E4CDB9028955A90B0B56D3232E0F30C2D89FDAB49C173B7E5182B5C4129510A021AE5FDCF2EEF5D0E0D7F0F6FEAC1C9458FF7E986B1BB694D2A1405AFA2ED07B43A48FDD390AC768A25DD8610070728E97FE34D0C056CACA42107ADB8A7549087371C1A3D54ABF59510AAE0CF4331E422D1B9389FB095DA64C0F5BB8E2A607C46763"
    }
    };
    RestPlayback *playback = [[RestPlayback alloc] initWithJSONObject:[data objectForKey:[RestPlayback root]]];
    STAssertNotNil(playback, nil);
    STAssertEquals(playback.items.count, (NSUInteger) 2, nil);
}

@end
