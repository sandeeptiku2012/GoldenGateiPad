//
//  Alert.h
// PlayerPlatform
//
//  Created by Bryan Pauk on 1/29/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *easText;
@property (nonatomic) NSString *instruction;
@property (nonatomic) NSString *contentReplaceUrl;
@property (nonatomic) NSString *event;
@property (nonatomic) NSString *effective;
@property (nonatomic) NSString *expires;
@property (nonatomic) NSString *areaDesc;

-(Alert*)initWithIdentifier:(NSString*) identifier;
-(bool)hasMediaUrl;
-(NSString*)getAlertMessage;


@end
