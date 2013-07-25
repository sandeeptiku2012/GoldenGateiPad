//
//  ManifestParser.h
//  PlayerPlatformUtil
//
//  Created by Cory Zachman on 5/6/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManifestParser : NSObject
@property BOOL complete;
@property NSData *results;
@property NSURL *url;
@property NSURL *baseUrl;
-(void)parse;
-(void)parseParentManifest;
-(void)parseChildManifest;
@end
