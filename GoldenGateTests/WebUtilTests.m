//
//  WebUtilTests.m
//  GoldenGate
//
//  Created by Erik Engheim on 9/6/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "WebUtilTests.h"
#import "WebUtil.h"

@implementation WebUtilTests

- (void)testObjectForKeyPath
{
    NSDictionary *dict =
        @{
            @"a" : @{@"x" : @1, @"y" : @2},
            @"b" : @{@"x" : @3, @"y" : @4},
            @"c" : @[
                        @{
                            @"s" : @11, @"t" : @[
                                                    @{
                                                        @"C" : @200,
                                                        @"D" : @201
                                                     },
                                                    @{
                                                        @"C" : @202,
                                                        @"D" : @203
                                                    }
                                                ]
                        },
                        @{
                            @"s" : @33, @"t" : @[
                                                    @{
                                                        @"D" : @100,
                                                        @"C" : @101
                                                     },
                                                    @{
                                                        @"C" : @102,
                                                        @"D" : @103
                                                    }
                                                ]
                         }
                    ]
        };
    
    STAssertEquals(2, [[dict objectForKeyPath:@"a.y"] intValue], nil);
    STAssertEquals(3, [[dict objectForKeyPath:@"b.x"] intValue], nil);
    NSArray *array = [dict objectForKeyPath:@"c.s"];
    int count = [array count];
    
    STAssertEquals(2, count, nil);
    STAssertEquals(33, [[array objectAtIndex:1] intValue], nil);
    
    NSArray *array2 = [dict objectForKeyPath:@"c.t.C"];
    int value = [[[array2 objectAtIndex:1] objectAtIndex:0] intValue];
    NSLog(@"stuff %d", value);
    STAssertEquals(101, value, nil);

}

@end
