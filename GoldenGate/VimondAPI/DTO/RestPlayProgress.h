//
//  RestPlayProgress.h
//  GoldenGate
//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@class PlayProgress;

@interface RestPlayProgress : NSObject <JSONSerializable>

@property (strong, nonatomic) NSNumber *offsetSeconds;
- (PlayProgress*)playProgressObject;

@end
