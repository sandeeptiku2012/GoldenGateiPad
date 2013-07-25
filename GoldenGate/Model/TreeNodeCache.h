//
//  TreeNodeCache.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/30/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNodeCache : NSObject

- (void)clearCache;

- (void)storeNode:(id)node withKey:(id)key;
- (void)storeChildNodes:(NSArray *)childNodes forNodeWithKey :(id)key;
- (void)deleteNodeWithKey:(id)key;

- (id)nodeWithKey:(id)key;
- (id)childNodesForNodeWithKey:(id)key;

/*!
 @abstract
 If YES any new stored node with override the old one.
 Default is NO.
 @note
 This does not apply to storeChildNodes where the cache will be overridden regardless.
 */
@property (nonatomic, assign) BOOL overrideOldNodes;

@end
