//
//  SessionManager.h
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class AuthenticationClient;

typedef void (^AuthHandler)(BOOL success, NSString *message);

@interface SessionManager : NSObject

- (id)initWithAuthenticationClient:(AuthenticationClient *)authenticationClient;


@property (strong, readonly, nonatomic) User *currentUser;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password rememberMe:(BOOL)rememberMe completion:(AuthHandler)onComplete;
- (void)logout:(AuthHandler)onSuccess;
- (void)isUserAuthenticated:(AuthHandler)onComplete;
- (void)clearCookies;
- (id)sessionValueForKey:(NSString *)key;
- (void)setSessionValue:(id)value forKey:(NSString *)key;

@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *userName;
@property (assign, nonatomic) BOOL shouldRememberMe;

@end
