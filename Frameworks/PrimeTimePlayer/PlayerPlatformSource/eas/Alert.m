//
//  Alert.m
// PlayerPlatform
//
//  Created by Bryan Pauk on 1/29/13.
//  Copyright 2013, Comcast Corporation. This software and its contents are
//  Comcast confidential and proprietary. It cannot be used, disclosed, or
//  distributed without Comcast's prior written permission. Modification of this
//  software is only allowed at the direction of Comcast Corporation. All allowed
//  modifications must be provided to Comcast Corporation..
//

#import "Alert.h"

@implementation Alert

-(Alert*)initWithIdentifier:(NSString*) identifier
{
    self = [super init];
    
    if (self)
    {
        _identifier = identifier;
    }
    
    return self;
}


-(bool)hasMediaUrl
{
    return _contentReplaceUrl != nil && [_contentReplaceUrl rangeOfString:@".wav"].location == NSNotFound;
}

-(NSString*)getAlertMessage
{
    NSString *alertText = @"A ";
    alertText = [self append:alertText withString:_event];
    alertText = [self append:alertText withString:@" has been issued for the following counties "];
    alertText = [self append:alertText withString:_areaDesc];
    alertText = [self append:alertText withString:@" effective "];
    alertText = [self append:alertText withString:_effective];
    alertText = [self append:alertText withString:@" until "];
    alertText = [self append:alertText withString:_expires];
    alertText = [self append:alertText withString:@". "];
    alertText = [self append:alertText withString:_description];
    alertText = [self append:alertText withString:_instruction];
    return alertText;
}

-(NSString*)append:(NSString*)string withString:(NSString*)appendString
{
    if(appendString !=nil)
    {
        return [string stringByAppendingString:appendString];
    }
    else
    {
        return string;
    }
}

@end
