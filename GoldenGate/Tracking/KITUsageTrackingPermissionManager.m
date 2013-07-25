//
//  KITUsageTrackingPermissionManager.m
//  KIT
//
//  Created by Andreas Petrov on 12/20/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "KITUsageTrackingPermissionManager.h"

static NSString *kPermissionKey = @"trackingPermission";
static NSString *kPermissionYes = @"YES";
static NSString *kPermissionNo  = @"NO";


enum
{
    kButtonIndexOptOut,
    kButtonIndexOptIn
};

@interface KITUsageTrackingPermissionManager()

@property (copy) PermissionBlock executionBlock;

@end

@implementation KITUsageTrackingPermissionManager

+ (KITUsageTrackingPermissionManager *)instance
{
    static KITUsageTrackingPermissionManager *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


+ (void)askForTrackingPermissionWithQuestion:(NSString *)questionString
                                       title:(NSString *)title
                                   yesAnswer:(NSString *)yesAnswer
                                    noAnswer:(NSString*)noAnswer
                                  completion:(PermissionBlock)onComplete
{
    [[KITUsageTrackingPermissionManager instance] askForTrackingPermissionWithQuestion:questionString title:title yesAnswer:yesAnswer noAnswer:noAnswer completion:onComplete];
}

- (void)askForTrackingPermissionWithQuestion:(NSString *)questionString
                                       title:(NSString *)title
                                   yesAnswer:(NSString *)yesAnswer
                                    noAnswer:(NSString*)noAnswer
                                  completion:(PermissionBlock)onComplete
{

    // For testing purposes we won't give the user the possibility to opt out.
    onComplete(YES);
    
//    NSString *permission = [[NSUserDefaults standardUserDefaults] objectForKey:kPermissionKey];
//    if (permission == nil)
//    {
//        self.executionBlock = onComplete;
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:questionString delegate:self cancelButtonTitle:noAnswer otherButtonTitles:yesAnswer, nil];
//        [alertView show];
//    }
//    else
//    {
//        BOOL permissionGranted = [permission isEqualToString:kPermissionYes];
//        onComplete(permissionGranted);
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL permissionGranted = buttonIndex == kButtonIndexOptIn;
    
    [[NSUserDefaults standardUserDefaults]setValue:permissionGranted ? kPermissionYes : kPermissionNo forKey:kPermissionKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.executionBlock(permissionGranted);
}


@end
