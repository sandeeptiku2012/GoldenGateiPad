//
//  KITTrayView+.h
//  KIT
//
//  Created by Andreas Petrov on 9/4/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//@class KITTrayView;
//
//@protocol KITTrayViewDelegate <NSObject>
//
//@optional
//- (void)trayViewDidStartContracting:(KITTrayView*)trayView;
//- (void)trayViewDidStartExpanding:(KITTrayView*)trayView;
//
//- (void)trayViewDidFinishContracting:(KITTrayView*)trayView;
//- (void)trayViewDidFinishExpanding:(KITTrayView*)trayView;
//
//@end

extern NSString *const kNotificationTrayViewDidStartContracting;
extern NSString *const kNotificationTrayViewDidFinishContracting;
extern NSString *const kNotificationTrayViewDidStartExpanding;
extern NSString *const kNotificationTrayViewDidFinishExpanding;
extern NSString *const kNotificationTrayViewDidStartDragging;
extern NSString *const kNotificationTrayViewDidFinishDragging;


@interface KITTrayView : UIView

// The view the user will tap or drag to open the tray.
// If none is set, the last subview will be used as the tab view.
// If that can't be found
@property (weak, nonatomic) IBOutlet UIView *trayTabView;

@property (assign, nonatomic) NSTimeInterval expansionAnimationDuration;
@property (assign, nonatomic) NSTimeInterval contractionAnimationDuration;
@property (assign, nonatomic) BOOL bounces;
@property (assign, nonatomic) CGFloat bouncePadding;
//@property (weak, nonatomic) id<KITTrayViewDelegate> delegate;

- (void)contractTray;
- (void)expandTray;

@end
