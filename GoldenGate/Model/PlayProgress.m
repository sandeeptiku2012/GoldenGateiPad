//
//  Created by Andreas Petrov on 12/5/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "PlayProgress.h"


@implementation PlayProgress
{

}

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    
    PlayProgress *operandB = object;
    return self.assetID == operandB.assetID && self.offsetSeconds == operandB.offsetSeconds;
}

@end