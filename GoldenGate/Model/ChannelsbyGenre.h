//
//  ChannelsbyGenre.h
//  GoldenGate
//
//  Created by Satish Basavaraj on 15/05/13.
//  Copyright (c) 2013 Valtech. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Channel.h"
#import "RestProgramSortBy.h"


//Model to store channels grouped by genre

@interface ChannelsbyGenre : NSObject

-(int)itemsCount;
-(NSDictionary*)objectAtIndex:(int)iIndex;
-(NSArray*)objectsForGenre:(NSString*)genreKey;
-(void)addChannel:(Channel*)channel;
-(void)addChannelsFromArray:(NSArray*)channels;
-(void)clearAll;

@end
