//
//  WebUtil.h
//  Systemspill
//
//  Created by Erik Engheim on 23.07.12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WebUtil)
+ (NSDictionary *)dictionaryFromJSON:(NSData *)data error:(NSError **)err;
- (id)objectForKeyPath:(NSString *)path;
- (id)objectForKeyList:(id)key, ...;
- (NSString *) queryString;
@end




