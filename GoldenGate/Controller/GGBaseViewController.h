//
//  GGBaseViewController.h
//  GoldenGate
//
//  Created by Andreas Petrov on 8/22/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingPathGenerating.h"

/*!
 @abstract
 Inherit this to make your UIViewController handle localization without
 using multiple nib files for different localizations.
 It also facilitates easy adding of operations to a backround queue
 that will be cancelled when the view controller dissapears.
*/
@interface GGBaseViewController : UIViewController <TrackingPathGenerating>

/*!
 @abstract
 An operation queue whos operations will be cancelled on viewWillDissapear.
 */
@property (strong) NSOperationQueue *viewControllerOperationQueue;

- (void)showError:(NSError *)error;

#pragma mark - Threading
- (NSOperation*)runOnBackgroundThread:(void (^)())block;
- (NSOperation*)runOnUIThread:(void (^)())block;



@end
