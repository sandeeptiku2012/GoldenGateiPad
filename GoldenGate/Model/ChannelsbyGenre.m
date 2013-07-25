//
//  ChannelsbyGenre.m
//  GoldenGate
//
//  Created by Satish Basavaraj on 15/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//

#import "ChannelsbyGenre.h"


@interface ChannelsbyGenre()

@property (strong, nonatomic) NSMutableDictionary *channelsByGenre; //dictionary to store channels by genre
@property (strong, nonatomic) NSMutableArray *sortedKeyList; //list of genre sorted in Alphabetical order


@end

@implementation ChannelsbyGenre

-(id)init
{
    if (self = [super init]) {
        _channelsByGenre = [NSMutableDictionary new];
        _sortedKeyList = [NSMutableArray new];
    }
    return self;
}

-(int)itemsCount
{
    return [self.channelsByGenre count];
}

//obtains list of channels for a genre at index. Genres are sorted based on alphabetical order
-(NSDictionary*)objectAtIndex:(int)iIndex
{
    NSDictionary* dictRet = nil;
    id key = [self getKeyForIndex:iIndex];
    if (key) {
        dictRet = [NSDictionary dictionaryWithObject:[self.channelsByGenre objectForKey:key] forKey:key];
    }
    
    return dictRet;
}

//Obtain channels for a genre
-(NSArray*)objectsForGenre:(NSString*)genreKey
{
    NSArray* arrRet = [self.channelsByGenre objectForKey:genreKey];    
    return arrRet;
}

//Get genre at an index. Genres are sorted alphabetically
-(id)getKeyForIndex:(int)iIndex
{
    id retKey = nil;
    
    if (iIndex < [self.sortedKeyList count]) {
        retKey = [self.sortedKeyList objectAtIndex:iIndex];
    }
    
    return retKey;
}


//Add channel to a genre. Channels for a genre are stored in a dictionary
-(void)addChannelForGenre:(Channel*)channel genre:(NSString*)key
{
    NSMutableArray* arrForKey = [self.channelsByGenre objectForKey:key];
    if (arrForKey) {
        [arrForKey addObject:channel];
    }else
    {
        arrForKey = [NSMutableArray new];
        [arrForKey addObject:channel];
        [self insertKeyToSortedArray:key];
        [self.channelsByGenre setObject:arrForKey forKey:key];
        
    }
}

//Add a channel to the model.
//Channels without genre are stored under miscellaneous
-(void)addChannel:(Channel*)channel
{
    if (channel&&([channel isKindOfClass:[Channel class]])) {
        NSString* strGenre = channel.strGenre;
        if (nil == strGenre) {
            strGenre = NSLocalizedString(@"MiscellaneousLKey", @"");
        }
        [self addChannelForGenre:channel genre:strGenre];
        
    }

}


-(void)addChannelsFromArray:(NSArray*)channels
{
    for (Channel* channel in channels) {
        [self addChannel:channel];
    }
}

//Reset the model
-(void)clearAll
{
    [self.channelsByGenre removeAllObjects];
    [self.sortedKeyList removeAllObjects];
}

//sort and maintain Genre list
-(void)insertKeyToSortedArray:(NSString*)key
{
    if (key) {
        
        
        NSUInteger newIndex =[self.sortedKeyList indexOfObject:key
                                                 inSortedRange:(NSRange){0, [self.sortedKeyList count]}
                                                       options:NSBinarySearchingInsertionIndex
                                               usingComparator:^(id obj1, id obj2) {
                                                   return [[NSString stringWithString:obj1] caseInsensitiveCompare:obj2];
                                               }
                              ];
        [self.sortedKeyList insertObject:key atIndex:newIndex];
    }
    
}



@end
