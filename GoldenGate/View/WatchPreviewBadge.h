//
//  WatchPreviewBadge.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/17/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchPreviewBadge : UIView

typedef enum
{
    WatchPreviewBadgeModePreview,
    WatchPreviewBadgeModeWatch
} WatchPreviewBadgeMode;

@property (assign, nonatomic) WatchPreviewBadgeMode mode;

@end
