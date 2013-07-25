//
//  DrmStringGenerator.h
//  PlayerPlatformUtil
//
//  Created by Cory Zachman on 4/26/13.
//  Copyright (c) 2013 Cory Zachman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrmStringGenerator : NSObject
+(NSString*)generateDrmString:(NSString*)xsctToken offline:(BOOL)offline;
@end
