//
//  XIDMAuthTokens.h
//  XIDM
//
//  Created by Brad Spenla on 4/8/13.
//  Copyright (c) 2011 Comcast Interactive Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XIDMAuthToken.h"

extern NSString * const kXIDMAuthTokensKey;

@class XIDMAuthTokens;

@interface XIDMAuthTokenStore : NSObject
- (BOOL)save:(NSData *)tokens error:(NSError **)error;
- (NSData *)load;
- (BOOL)removeAll;
@end;

@interface XIDMAuthTokens : NSObject {
  dispatch_queue_t tokenQueue;
}
+ (XIDMAuthTokens *)loadFromStore:(XIDMAuthTokenStore *)store;
- (id)initWithTokens:(NSMutableDictionary *)tokens;
@property(strong) XIDMAuthToken *metadata;
@property(strong) XIDMAuthToken *cima;
@property(strong) XIDMAuthToken *xact;
@property(strong) XIDMAuthToken *xsct;
@end
