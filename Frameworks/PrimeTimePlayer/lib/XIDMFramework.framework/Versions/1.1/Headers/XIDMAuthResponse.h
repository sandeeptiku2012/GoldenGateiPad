//
//  XIDMAuthResponse.h
//  XIDM
//
//  Created by Brad Spenla on 4/9/13.
//  Copyright (c) 2011 Comcast Interactive Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XIDMAuthToken.h"
#import "XIDMError.h"

@interface XIDMAuthResponse : NSObject
- (id)initWithServerDate:(NSDate *)serverDate;
- (BOOL)parseXMLData:(NSData *)data error:(NSError **)error;
- (void)updateWithLicenseDictionary:(NSDictionary *)dictionary;
- (void)updateWithAttributes:(NSDictionary *)attributes;
@property(strong) NSData *data;//input
@property(strong) NSDate *serverDate;//optional input
@property(strong) NSDate *notOnOrAfter;//output
@property(strong) NSNumber *messageStatus;
@property(strong) NSString *messageType;
@property(strong) NSString *messageID;
@property(strong) XIDMAuthToken *token;//output
@property(strong) XIDMError *error;//output
@end

