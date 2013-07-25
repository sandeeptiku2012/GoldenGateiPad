//
//  XIDMAuthToken.h
//  XIDM
//
//  Created by Brad Spenla on 4/8/13.
//  Copyright (c) 2011 Comcast Interactive Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct XIDMAuthTokenName {
	__unsafe_unretained NSString *metadata;
	__unsafe_unretained NSString *cima;
	__unsafe_unretained NSString *xact;
	__unsafe_unretained NSString *xsct;
} XIDMAuthTokenName;

@interface XIDMAuthToken : NSObject <NSCoding>
@property(strong) NSString *value;
@property(strong) NSDate *issued;
@property(strong) NSDate *notBefore;
@property(strong) NSDate *notOnOrAfter;
@property(assign) NSTimeInterval duration;
@property(readonly) BOOL valid;//base64Encoded value
- (NSData *)decodedValue;
@end

