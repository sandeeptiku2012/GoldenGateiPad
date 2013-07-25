//
//  TreeNodeCache.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/30/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "TreeNodeCache.h"

@interface TreeNodeCache()

@property (strong) NSCache *nodeCache;
@property (strong) NSCache *childNodeCache;

@end

@implementation TreeNodeCache

- (id)init
{
    if ((self = [super init]))
    {
        _nodeCache      = [NSCache new];
        _childNodeCache = [NSCache new];
    }

    return self;
}

- (void)clearCache
{
    [_nodeCache removeAllObjects];
    [_childNodeCache removeAllObjects];
}

- (void)storeNode:(id)node withKey:(id)key
{
    BOOL shouldStoreNode = _overrideOldNodes || (!_overrideOldNodes && [self.nodeCache objectForKey:key] == nil);
    if (shouldStoreNode && node && key)
    {
        [self.nodeCache setObject:node forKey:key];
    }
}

- (void)storeChildNodes:(NSArray *)childNodes forNodeWithKey :(id)key
{
    if (childNodes && key)
    {
        [self.childNodeCache setObject:childNodes forKey:key];
    }
}

- (void)deleteNodeWithKey:(id)key
{
    [_nodeCache removeObjectForKey:key];
}

- (id)nodeWithKey:(id)key
{
    return [_nodeCache objectForKey:key];
}

- (id)childNodesForNodeWithKey:(id)key
{
    return [_childNodeCache objectForKey:key];
}

@end
