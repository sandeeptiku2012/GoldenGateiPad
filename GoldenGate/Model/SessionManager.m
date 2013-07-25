//
//  SessionManager.m
//  GoldenGate
//
//  Created by Andreas Petrov on 10/26/12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "SessionManager.h"
#import "User.h"
#import "AuthenticationClient.h"
#import "RestLoginResult.h"
#import "GGBackgroundOperationQueue.h"
#import "KeychainItemWrapper.h"
#import "VimondStore.h"

#define kRememberMeKey @"RememberMe"

@interface  SessionManager()

@property (strong, nonatomic) KeychainItemWrapper *keychain;
@property (weak, nonatomic) AuthenticationClient *authenticationClient;
@property (strong, nonatomic) NSMutableDictionary *sessionVariables;
@property (strong, readwrite, nonatomic) User *currentUser;

@end

@implementation SessionManager

- (id)initWithAuthenticationClient:(AuthenticationClient *)authenticationClient
{
    if ((self = [super init]))
    {
        _authenticationClient = authenticationClient;
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"GoldenGate" accessGroup:nil];
        _sessionVariables = [NSMutableDictionary new];
    }

    return self;
}

- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
               rememberMe:(BOOL)rememberMe
               completion:(AuthHandler)onComplete
{
    [self clearCookies];
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    [[GGBackgroundOperationQueue sharedInstance] addOperationWithBlock:^
    {
        // clear existing cookies when trying to log in again just to be sure.
        RestLoginResult *loginResult = [_authenticationClient loginWithUsername:userName password:password rememberMe:rememberMe];
        BOOL authenticationSuccessful = [loginResult.code isEqualToString:kAuthenticationOk];
        if (authenticationSuccessful)
        {
            self.currentUser = [self userFromLoginResult:loginResult];
        }

        [currentQueue addOperationWithBlock:^
        {
            if (onComplete)
            {
                BOOL success = self.currentUser != nil;
                if (success && rememberMe)
                {
                    self.userName = userName;
                    self.password = password;
                }
                
                onComplete(success, loginResult.text);
            }
        }];
    }];
}

- (User*)userFromLoginResult:(RestLoginResult*)loginResult
{
    return [[User alloc] initWithId:loginResult.userId];
}

- (void)isUserAuthenticated:(AuthHandler)onComplete
{
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    [[GGBackgroundOperationQueue sharedInstance] addOperationWithBlock:^
    {
        RestLoginResult *loginResult = [_authenticationClient isSessionAuthenticated];
        BOOL isAuthenticated = [loginResult.code isEqualToString:kSessionAuthenticated];
        if (isAuthenticated)
        {
            self.currentUser = [self userFromLoginResult:loginResult];
        }
        else
        {
            if (self.currentUser != nil)
            {
                // Fire off ONE notification that authentication has failed the first time the user object is set to nil.
                [[NSNotificationCenter defaultCenter]postNotificationName:kAuthenticationFailedNotification object:nil];
            }
            
            self.currentUser = nil;
        }
        
        [currentQueue addOperationWithBlock:^
        {
            if (onComplete)
            {
                onComplete(isAuthenticated, loginResult.text);
            }
        }];
    }];
}

- (void)setCurrentUser:(User *)currentUser
{
    BOOL userChanged = currentUser != _currentUser;
    if (userChanged)
    {
        [self clearSessionVariables];
    }
    
    _currentUser = currentUser;
}

- (void)logout:(AuthHandler)onComplete
{
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    [[GGBackgroundOperationQueue sharedInstance] addOperationWithBlock:^
    {
        RestLoginResult *loginResult = [_authenticationClient logout];
        if ([loginResult.code isEqualToString:kSessionInvalidated])
        {
            self.currentUser = nil;
        }

        [currentQueue addOperationWithBlock:^
        {
            if (onComplete)
            {
                BOOL success = self.currentUser == nil;
                if (success)
                {
                    [self clearKeychain];
                    [self clearCookies];
                }
                
                onComplete(success, loginResult.text);
            }
        }];
    }];
}

- (void)clearKeychain
{
    self.userName = nil;
    self.password = nil;
    self.shouldRememberMe = NO;
    [self.keychain resetKeychainItem];
}

- (void)clearSessionVariables
{
    [_sessionVariables removeAllObjects];
}

- (void)clearCookies
{
    NSURL *baseURL = [NSURL URLWithString:[VimondStore sharedStore].baseURL];
    if (baseURL) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:baseURL];
        for (NSHTTPCookie *cookie in cookies)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
        }
    }

}

- (NSString *)userName
{
    return [self.keychain objectForKey:(__bridge id)kSecAttrAccount];
}


- (void)setUserName:(NSString *)userName
{
    [self.keychain setObject:userName forKey:(__bridge id)kSecAttrAccount];
}

- (NSString *)password
{
    return [self.keychain objectForKey:(__bridge id)kSecValueData];
}

- (void)setPassword:(NSString *)password
{
    
    [self.keychain setObject:password forKey:(__bridge id)kSecValueData];
}

- (BOOL)shouldRememberMe
{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:kRememberMeKey]boolValue];
}

- (void)setShouldRememberMe:(BOOL)shouldRememberMe
{
    [[NSUserDefaults standardUserDefaults]setObject:@(shouldRememberMe) forKey:kRememberMeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (id)sessionValueForKey:(NSString *)key {
    return [_sessionVariables objectForKey:key];
}

- (void)setSessionValue:(id)value forKey:(NSString *)key
{
    [_sessionVariables setObject:value forKey:key];
}

@end
