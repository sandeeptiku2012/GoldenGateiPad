//
//  CAAnimation+Blocks.h
//  CAAnimationBlocks
//
//  Created by xissburg on 7/7/11.
//  Copyright 2011 xissburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/*!
 So we can use CAAnimation with blocks and not just delegates.
*/
@interface CAAnimation (BlocksAddition)

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)();

@end
