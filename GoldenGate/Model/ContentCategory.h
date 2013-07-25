//
//  ContentCategory.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/21/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "Entity.h"

@interface ContentCategory : Entity

typedef enum
{
    ContentCategoryLevelTop,
    ContentCategoryLevelMain,
    ContentCategoryLevelSub,
    ContentCategoryLevelChannel,
    ContentCategoryLevelShow,
    ContentCategoryLevelUnknown
} ContentCategoryLevel;

@property (assign, nonatomic) ContentCategoryLevel categoryLevel;

@end
