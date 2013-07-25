//
//  VideoPlayerTrayView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 9/6/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "KITTrayView.h"

@class KITGridLayoutView;

@interface VideoPlayerTrayView : KITTrayView

- (void)clearDynamicContent;
- (void)addViewToDynamicContent:(UIView*)view;
- (void)selectDynamicContentAtIndex:(int)index;

typedef enum
{
    VideoPlayerTrayViewTabLocationAbove,
    VideoPlayerTrayViewTabLocationBelow
} VideoPlayerTrayViewTabLocation;

@property (copy, nonatomic) NSString *tabLabelString;
@property (copy, nonatomic) UIImage *tabIconImage;

@property (assign, nonatomic) VideoPlayerTrayViewTabLocation tabLocation;
@property (weak, nonatomic) IBOutlet KITGridLayoutView *dynamicContentContainer;
@property (assign, nonatomic) BOOL fadeItemsToLeftOfActive;

@end
