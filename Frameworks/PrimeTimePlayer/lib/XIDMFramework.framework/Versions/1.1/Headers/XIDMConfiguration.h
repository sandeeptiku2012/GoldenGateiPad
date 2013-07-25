//
//  XIDMConfiguration.h
//  XIDM
//
//  Created by Brad Spenla on 4/5/13.
//  Copyright (c) 2011 Comcast Interactive Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XIDMConfiguration : NSObject
- (id)initWithURL:(NSURL *)url;
@property(strong) NSURL *url;
@property(strong) NSDate *expires;//optional input
@property(strong) NSURL *cimaURL;//output
@property(strong) NSURL *metadataURL;//output
@property(strong) NSURL *xactURL;//output
@property(strong) NSURL *xsctURL;//output
@property(strong) NSURL *provisionURL;//output
@property(strong) NSURL *deprovisionURL;//output
@property(strong) NSString *productType;//output
@property(readonly) BOOL complete;
@property(readonly) BOOL expired;
- (BOOL)parseXMLData:(NSData *)data error:(NSError **)error;
@end
