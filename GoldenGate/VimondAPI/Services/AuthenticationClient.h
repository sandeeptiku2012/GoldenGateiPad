#import <Foundation/Foundation.h>
#import "RestClient.h"

@class RestLoginResult;

/*!
 @abstract
 This class handles the communication with the Web-api for logging in and out.
 */
@interface AuthenticationClient : RestClient

- (id)initWithBaseURL:(NSString *)baseURL;

/*!
 @abstract
 Checks if we have an already valid authentication cookie.
 */
- (RestLoginResult *)isSessionAuthenticated;

/*!
 @abstract
 Log in using username and password.
 if rememberMe is YES then the retrieved authentication cookie will have a long expiry time.
 */
- (RestLoginResult *)loginWithUsername:(NSString *)string password:(NSString *)password rememberMe:(BOOL)rememberMe;

/*!
 @abstract
 Tell the web-api to invalidate your current authentication cookie.
 */
- (RestLoginResult *)logout;

@end