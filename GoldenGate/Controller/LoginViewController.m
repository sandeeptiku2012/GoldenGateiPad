//
//  LoginViewController.m
//  GoldenGate
//
//  Created by Andreas Petrov on 22.08.12.
//  Copyright (c) 2012 Knowit. All rights reserved.
//

#import "LoginViewController.h"
#import "VimondStore.h"
#import "GGCheckBoxButton.h"
#import "KITLinkedTextField.h"
#import "YellowButton.h"
#import "CategoryNavigator.h"
#import "GGLogoView.h"
#import "KITUsageTrackingPermissionManager.h"
#import "GGUsageTracker.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet KITLinkedTextField *usernameField;
@property (weak, nonatomic) IBOutlet KITLinkedTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView     *loginProgressContainerView;
@property (weak, nonatomic) IBOutlet UIView     *loginContainerView;
@property (weak, nonatomic) IBOutlet UIView     *tapToDismissView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginSpinner;
@property (weak, nonatomic) IBOutlet GGCheckBoxButton *rememberMeCheckBox;
@property (weak, nonatomic) IBOutlet YellowButton *signInButton;
@property (weak, nonatomic) SessionManager *sessionMgr;


// DEBUG VIEWS
@property (weak, nonatomic) IBOutlet UIView *serverChooserView;
@property (weak, nonatomic) IBOutlet UILabel *currentBaseURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentImageServiceBaseURLLabel;
@property (weak, nonatomic) IBOutlet YellowButton *changeBaseURLButton;

#define kTitleViewOriginOffset 2
#define kKillAppButtonIndex 1

@end

@implementation LoginViewController
@synthesize signInButton = _signInButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setupLogoTitleView];
    
#if TESTING
    [self setupServerChooserView];
#endif
    
    self.sessionMgr = [VimondStore sessionManager];
    
    self.usernameField.placeholder = NSLocalizedString(@"EmailLKey", @"");

    
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tapToDismissView addGestureRecognizer:tapRecog];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.rememberMeCheckBox.selected = self.sessionMgr.shouldRememberMe;
    self.usernameField.text = self.sessionMgr.userName;
    self.passwordField.text = self.sessionMgr.password;
    
    [self hideLoginProgress];
    [self dismissKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [KITUsageTrackingPermissionManager askForTrackingPermissionWithQuestion:NSLocalizedString(@"TrackingPermissionLKey", @"")
                                                                      title:NSLocalizedString(@"TrackingPermissionTitleLKey", @"")
                                                                  yesAnswer:NSLocalizedString(@"YesLKey", @"")
                                                                   noAnswer:NSLocalizedString(@"NoLKey", @"")
                                                                 completion:^(BOOL permitted)
     {
         if (permitted)
         {
             [[GGUsageTracker sharedInstance] startSession];
         }
         
         if (self.sessionMgr.shouldRememberMe)
         {
             [self checkLoginStatus];
         }
     }];
}

- (void)dismissKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)setupLogoTitleView
{
    // Jumping through hoops to center the logo view.
    UIView *logoView = [[GGLogoView alloc]init];
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat yOrigin = (int)((navBarHeight / 2) - (logoView.frame.size.height / 2)) - kTitleViewOriginOffset; // Truncate to int to avoid half float pixels.
    CGRect logoViewFrame = logoView.frame;
    logoViewFrame.origin.y = yOrigin;
    logoView.frame = logoViewFrame;

    // Create a container for the logo view to reside in. This is the only way we can control the origin of the logo.
    UIView *logoContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, logoView.frame.size.width, navBarHeight)];
    [logoContainer addSubview:logoView];
    self.navigationItem.titleView = logoContainer;
}

// This code will run in testing versions of the app only
- (void)setupServerChooserView
{
    self.serverChooserView.hidden = NO;
    self.currentBaseURLLabel.text = [VimondStore sharedStore].baseURL;
    self.currentImageServiceBaseURLLabel.text = [VimondStore sharedStore].imageServiceBaseURL;
}

- (void)hideLoginProgress
{
    self.changeBaseURLButton.enabled = YES;
    self.loginProgressContainerView.hidden  = YES;
    self.loginContainerView.hidden          = NO;
    [self.loginSpinner stopAnimating];
    
    [self.usernameField becomeFirstResponder];
}

- (void)showLoginProgress
{
    self.changeBaseURLButton.enabled = NO;
    self.loginProgressContainerView.hidden  = NO;
    self.loginContainerView.hidden          = YES;
    [self.loginSpinner startAnimating];
}

- (void)showMainCategories
{
    [self runOnBackgroundThread:^
    {
        NSUInteger rootId = [[[VimondStore categoryStore]rootCategoryID:nil]unsignedIntegerValue];
        [CategoryNavigator navigateToCategoryWithId:rootId fromViewController:self completionHandler:nil];
    }];
}

- (void)checkLoginStatus
{
    [self showLoginProgress];
    [self.sessionMgr isUserAuthenticated:^(BOOL success, NSString *message)
    {
        if (success)
        {
            [self showMainCategories];
        }
        else
        {
            [self hideLoginProgress];
        }
    }];
}

// This code will run in testing versions of the app only
- (IBAction)changeBaseURL:(UIButton*)sender
{
    VimondStore *vimondStore = [VimondStore sharedStore];
    NSArray *availableBaseURLs = vimondStore.baseURLArrayFromProperties;
    NSUInteger newBaseURLIndex = (vimondStore.baseURLIndex + 1) % availableBaseURLs.count;
    vimondStore.baseURLIndex = newBaseURLIndex;
    [self setupServerChooserView];
    
    [self.sessionMgr clearCookies];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Base URL changed."
                                                       message:@"You must restart the application completely for the changes to take effect"
                                                      delegate:self
                                             cancelButtonTitle:@"Do Nothing"
                                             otherButtonTitles:@"Kill App", nil];
    [alertView show];
}

- (IBAction)signIn:(id *)sender
{
    BOOL rememberMe = _rememberMeCheckBox.selected;
    self.sessionMgr.shouldRememberMe = rememberMe;
    [self showLoginProgress];
    [self.sessionMgr loginWithUserName:_usernameField.text
                                           password:_passwordField.text
                                         rememberMe:rememberMe
                                         completion:^(BOOL success, NSString *message)
    {
        if (success)
        {
            [self showMainCategories];
        }
        else
        {
            [self hideLoginProgress];
            [self.passwordField becomeFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to sign in"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            alert.accessibilityLabel=@"Unable to sign in";
        }
    }];
}

// This code will run in testing versions of the app only
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kKillAppButtonIndex)
    {
        exit(0);
    }
}

- (NSString *)generateTrackingPath
{
    return @"/Login_View";
}

@end
