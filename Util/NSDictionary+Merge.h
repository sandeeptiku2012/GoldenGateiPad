//
//  NSDictionary+Merge.h
//  Systemspill
//
//  Created by Erik Engheim on 18.06.12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Merge)
+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2;
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict;
@end
