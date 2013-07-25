//
//  XIDM.h
//  XIDM
//
//  Created by Brad Spenla on 4/5/13.
//  Copyright (c) 2011 Comcast Interactive Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XIDMAuthTokens.h"
#import "XIDMAuthTokens.h"
#import "XIDMConfiguration.h"
#import <drmNativeInterface/DRMInterface.h>

#define RESET_TOKENS NO

extern NSString * const kXIDMUnprovisionedNotification;

typedef void (^XIDMSessionTokenRenewed)(XIDMAuthToken *token);
typedef void (^XIDMWorkflowComplete)(BOOL success, BOOL cancelled, NSError *error);
typedef void (^XIDMLicenseAcquired)(DRMLicense *license, NSError *error);
typedef void (^XIDMPlaylistAcquired)(NSURL *playlist, NSError *error);

@interface XIDM : NSObject

//+ (XIDM *)sharedInstance;
- (id)initWithTokens:(XIDMAuthTokens *)tokens andConfiguration:(XIDMConfiguration *)configuration;

- (BOOL)validSession;
- (BOOL)provisioned;
- (BOOL)authenticated;
- (void)loginWorkflowWithUsername:(NSString *)username andPassword:(NSString *)password completionHandler:(XIDMWorkflowComplete)completionHandler;
- (void)renewSessionWorkflow:(XIDMWorkflowComplete)completionHandler;
//- (void)deprovisionWorkflow:(XIDMWorkflowComplete)completionHandler;
- (void)sessionCreateWorkflow:(XIDMWorkflowComplete)completionHandler;
- (void)renewSessionIfNeeded:(XIDMSessionTokenRenewed)completionHandler;
- (void)applicationDidBecomeActive:(NSNotification *)note;
- (void)acquireOfflinePlaylistForURL:(NSURL *)url completionHandler:(XIDMPlaylistAcquired)completionHandler;
- (void)acquireStreamingPlaylistForURL:(NSURL *)url completionHandler:(XIDMPlaylistAcquired)completionHandler;
- (void)acquirePersistentLicenseForURL:(NSURL *)url completionHandler:(XIDMLicenseAcquired)completionHandler;

@property(readonly) XIDMAuthTokens *tokens;
@property(readonly) XIDMConfiguration *configuration;
@property(readonly) BOOL configured;

@end
