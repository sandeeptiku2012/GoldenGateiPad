//
//  LoadingView.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/24/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;

@protocol LoadingViewDelegate <NSObject>

- (void)retryButtonWasPressedInLoadingView:(LoadingView*)loadingView;

@end

@interface LoadingView : UIView

typedef enum
{
    LoadingViewStyleForDarkBackground,
    LoadingViewStyleForLightBackground,
} LoadingViewStyle;


/*!
 @abstract shows the loading view ,starts the progress spinner and shows the loading label.
 */
- (void)startLoadingWithText:(NSString*)string;

/*!
 @abstract hides the loading label and replaces it with a retry button. Call when an error occurs.
 */
- (void)showRetryWithMessage:(NSString*)string;

/*!
 @abstract Just show a message in the loading view. Nothing else.
 */
- (void)showMessage:(NSString*)message;

/*!
 @abstract hides the entire loading view.
 */
- (void)endLoading;


@property (weak, nonatomic) IBOutlet id<LoadingViewDelegate> delegate;

@property (assign, nonatomic) LoadingViewStyle style;

@end
