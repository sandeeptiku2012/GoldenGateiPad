//
//  AppDelegate.m
//  GoldenGate
//
//  Created by Andreas Petrov on 8/13/12.
//  Copyright (c) 2012 Andreas Petrov. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GGAppearanceManager.h"
#import "TestFlight.h"
#import "GGUsageTracker.h"
#import "NavActionExecutor.h"

#if RUN_KIF_TESTS
#import "EXTestController.h"
#endif

//#import <PonyDebugger/PonyDebugger.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [GGAppearanceManager configureAppearance];
    
    [self showLoginWindow];
#if RUN_KIF_TESTS
    [[EXTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete. When running on CI, this lets you check the return value for pass/fail.
        //Ankit Vyas
        //exit([[EXTestController sharedInstance] failureCount]);
    }];
#endif
    return YES;
}

- (void)showLoginWindow
{
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[GGUsageTracker sharedInstance]endSession];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [NavActionExecutor clearViewControllerCache];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
