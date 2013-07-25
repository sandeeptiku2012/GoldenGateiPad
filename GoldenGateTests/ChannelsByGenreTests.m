//
//  ChannelsByGenreTests.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 23/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelsByGenreTests.h"
#import "ChannelsbyGenre.h"
#import <OCMock/OCMock.h>

@interface ChannelsbyGenre()
-(void)addChannelForGenre:(Channel*)channel genre:(NSString*)key;
-(void)addChannelsFromArray:(NSArray*)channels;
@end


@implementation ChannelsByGenreTests


-(Channel*)getValidChannel
{    
    Channel* channel = [self getChannelByNameAndGenre:@"Test Genre" genre:@"Test Channel"];
    return channel;
}

-(Channel*)getChannelByNameAndGenre:(NSString*)strName genre:(NSString*)strGenre
{
    Channel* channel = [Channel new];
    channel.strGenre = strGenre;
    channel.title = strName;
    return channel;
}

-(void)test_addChannelNil
{
    
    Channel* channel = nil;
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    id mock = [OCMockObject partialMockForObject:channelByGenre];
    [[mock reject] addChannelForGenre:channel genre:channel.strGenre];
    [channelByGenre addChannel:channel];
    [mock verify];
    
}

-(void)test_addChannelNonNil
{
    Channel* channel = [self getValidChannel];
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    id mock = [OCMockObject partialMockForObject:channelByGenre];
    [[mock expect] addChannelForGenre:channel genre:channel.strGenre];
    [channelByGenre addChannel:channel];
    [mock verify];
}

-(void)test_addChannelGenreNil
{
    Channel* channel = [self getValidChannel];
    channel.strGenre = nil;
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    id mock = [OCMockObject partialMockForObject:channelByGenre];
    [[mock expect] addChannelForGenre:channel genre:NSLocalizedString(@"MiscellaneousLKey", @"")];
    [channelByGenre addChannel:channel];
    [mock verify];
}

-(void)test_addChannelsFromArrayNil
{
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    id mock = [OCMockObject partialMockForObject:channelByGenre];
    [[mock reject] addChannel:[OCMArg any]];
    [channelByGenre addChannelsFromArray:nil];
    [mock verify];
    
}

-(void)test_addChannelsFromArrayNonNil
{
    NSMutableArray* arrayChannels = [NSMutableArray new];
    int iCountChannels = 5;
    for(int iCount =0; iCount < iCountChannels;iCount++)
    {
        [arrayChannels addObject:[self getValidChannel]];
    }
         
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    id mock = [OCMockObject partialMockForObject:channelByGenre];
         for(int iCount = 0; iCount<iCountChannels;iCount++)
         {
             [[mock expect] addChannel:[arrayChannels objectAtIndex:iCount ]];
         }
         [channelByGenre addChannelsFromArray:arrayChannels];
         [mock verify];
         
}

-(void)test_objectsForGenreNil
{
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    NSArray* arrRes = [channelByGenre objectsForGenre:nil];
    STAssertNil(arrRes, @"Array result should be nil");
}


-(void)test_objectsAtIndexNonNilSortedInput
{
    NSMutableArray* arrayChannels = [NSMutableArray new];
    Channel* channel = [self getChannelByNameAndGenre:@"Title1" genre:@"AGenre"];
    [arrayChannels addObject:channel];
    Channel* channel1 = [self getChannelByNameAndGenre:@"Title1" genre:@"BGenre"];
    [arrayChannels addObject:channel1];
    Channel* channel2 = [self getChannelByNameAndGenre:@"Title1" genre:@"CGenre"];
    [arrayChannels addObject:channel2];
    
    ChannelsbyGenre* channelsByGenre = [ChannelsbyGenre new];
    [channelsByGenre addChannelsFromArray:arrayChannels];
    
    NSDictionary* chanListRet = [channelsByGenre objectAtIndex:0];
    NSArray* arrayVal = [chanListRet allValues];
    NSArray* arrayChan = [arrayVal objectAtIndex:0];

    
    STAssertEqualObjects(channel, [arrayChan objectAtIndex:0], @"Unexpected object received");
    
    
}

-(void)test_objectsAtIndexNonNilNonSortedInput
{
    NSMutableArray* arrayChannels = [NSMutableArray new];

    Channel* channel1 = [self getChannelByNameAndGenre:@"Title1" genre:@"BGenre"];
    [arrayChannels addObject:channel1];
    Channel* channel2 = [self getChannelByNameAndGenre:@"Title1" genre:@"CGenre"];
    [arrayChannels addObject:channel2];
    Channel* channel = [self getChannelByNameAndGenre:@"Title1" genre:@"AGenre"];
    [arrayChannels addObject:channel];
    
    ChannelsbyGenre* channelsByGenre = [ChannelsbyGenre new];
    [channelsByGenre addChannelsFromArray:arrayChannels];
    
    NSDictionary* chanListRet = [channelsByGenre objectAtIndex:0];
    NSArray* arrayVal = [chanListRet allValues];
    NSArray* arrayChan = [arrayVal objectAtIndex:0];
    
    
    STAssertEqualObjects(channel, [arrayChan objectAtIndex:0], @"Unexpected object received");
}

-(void)test_clearAll
{
    NSMutableArray* arrayChannels = [NSMutableArray new];
    int iCountChannels = 5;
    for(int iCount =0; iCount < iCountChannels;iCount++)
    {
        [arrayChannels addObject:[self getValidChannel]];
    }
    
    ChannelsbyGenre* channelByGenre = [ChannelsbyGenre new];
    [channelByGenre addChannelsFromArray:arrayChannels];
    [channelByGenre clearAll];
    
    NSDictionary* dictRet = [channelByGenre objectAtIndex:0];
    STAssertNil(dictRet, @"Values not cleared");

}


@end
