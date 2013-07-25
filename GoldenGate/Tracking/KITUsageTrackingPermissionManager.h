//
//  KITUsageTrackingPermissionManager.h
//  KIT
//
//  Created by Andreas Petrov on 12/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PermissionBlock)(BOOL permitted);

/*!
 @abstract
 A little helper class that simplifies the process of obtaining user permission for tracking.
 */
@interface KITUsageTrackingPermissionManager : NSObject <UIAlertViewDelegate>

+ (void)askForTrackingPermissionWithQuestion:(NSString *)questionString
                                       title:(NSString *)title
                                   yesAnswer:(NSString *)yesAnswer
                                    noAnswer:(NSString *)noAnswer
                                  completion:(PermissionBlock)onComplete;

@end
