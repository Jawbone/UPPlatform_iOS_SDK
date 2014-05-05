//
//  UPManager.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPDefines.h"

#if UP_TARGET_OSX
#import <WebKit/WebKit.h>
#endif

extern NSString * const kUPPlatformDefaultRedirectURI;

@class UPSession, UPURLRequest, UPURLResponse;

/**
 * The authentication scope asked of the user.
 * @see https://jawbone.com/up/developer/authentication
 */
typedef NS_OPTIONS(NSUInteger, UPPlatformAuthScope)
{
    UPPlatformAuthScopeBasicRead         = 1 << 0,
    UPPlatformAuthScopeExtendedRead      = 1 << 1,
    UPPlatformAuthScopeLocationRead      = 1 << 2,
    UPPlatformAuthScopeFriendsRead       = 1 << 3,
    UPPlatformAuthScopeMoodRead          = 1 << 4,
    UPPlatformAuthScopeMoodWrite         = 1 << 5,
    UPPlatformAuthScopeMoveRead          = 1 << 6,
    UPPlatformAuthScopeMoveWrite         = 1 << 7,
    UPPlatformAuthScopeSleepRead         = 1 << 8,
	UPPlatformAuthScopeSleepWrite        = 1 << 9,
    UPPlatformAuthScopeMealRead          = 1 << 10,
    UPPlatformAuthScopeMealWrite         = 1 << 11,
    UPPlatformAuthScopeWeightRead        = 1 << 12,
    UPPlatformAuthScopeWeightWrite       = 1 << 13,
    UPPlatformAuthScopeCardiacRead       = 1 << 14,
    UPPlatformAuthScopeCardiacWrite      = 1 << 15,
    UPPlatformAuthScopeGenericRead       = 1 << 16,
    UPPlatformAuthScopeGenericWrite      = 1 << 17,
    UPPlatformAuthScopeAll               = 1 << 18
};

/**
 *  The completion block providing session information.
 *
 *  @param session The active session, or nil if the user is not authenticated.
 *  @param error   An error provided if authentication fails.
 */
typedef void(^UPPlatformSessionCompletion)(UPSession *session, NSError *error);

/**
 *  The completion block for basic platform requests.
 *
 *  @param request  The original request sent to the platform.
 *  @param response The response received from the platform.
 *  @param error    An error provided if the request failed.
 */
typedef void(^UPPlatformRequestCompletion)(UPURLRequest *request, UPURLResponse *response, NSError *error);

/**
 *  The base platform object, which manages the current session, authentication, and HTTP requests.
 */
@interface UPPlatform : NSObject

/**
 *  The current session, if active. Will be nil if the user has not authenticated.
 */
@property (nonatomic, readonly) UPSession *currentSession;

/**
 *  The redirect URI used during authentication.
 */
@property (nonatomic, readonly) NSString *redirectURI;

/**
 *  Flag to enable extra network logging. Setting this to YES will log all HTTP requests and responses sent via UPPlatform.
 */
@property (nonatomic, assign) BOOL enableNetworkLogging;

/**
 *  The singleton for the shared platform.
 */
+ (UPPlatform *)sharedPlatform;

/**
 *  The base URL for the platform.
 */
+ (NSString *)basePlatformURL;

/**
 *  The current version of the API.
 */
+ (NSString *)currentPlatformVersion;

/**
 *  Validates the current session.
 *  
 *  This method is useful in order to prevent any API requests from unexpectedly returning a 401 Unauthorized response when the user's access token is not valid.
 *
 *  @param completion The session completion block. If the session object passed to the completion block is not nil, the session is valid and API requests can be made.
 */
- (void)validateSessionWithCompletion:(UPPlatformSessionCompletion)completion;

/**
 * Refreshes the current access token.
 */
- (void)refreshAccessTokenWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret completion:(UPPlatformSessionCompletion)completion;

#if UP_TARGET_OSX

/**
 * Starts a user's session.
 *
 * This will present a WebView to perform the OAuth authentication flow, taking care of getting access token for HTTP requests.
 * An existing WebView can be provided, or one will be created in a new window if nil is provided.
 *
 * @param clientID     The client ID provided during application signup.
 * @param clientSecret The client secret provided during application signup.
 * @param webView      An existing WebView to perform authentication. Will create a new window with a single WebView if nil.
 * @param completion   The session completion block.
 */
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView completion:(UPPlatformSessionCompletion)completion;

/**
 * Starts a user's session.
 *
 * This will present a WebView to perform the OAuth authentication flow, taking care of getting access token for HTTP requests.
 * An existing WebView can be provided, or one will be created in a new window if nil is provided.
 *
 * @param clientID     The client ID provided during application signup.
 * @param clientSecret The client secret provided during application signup.
 * @param webView      An existing WebView to perform authentication. Will create a new window with a single WebView if nil.
 * @param authScope    Options to request specific auth scopes during authentication. Defaults to UPPlatformAuthScopeBasicRead.
 * @param completion   The session completion block.
 */
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion;

#else

/**
 *  Starts a user's session.
 *
 *  This will present a UIWebView to perform the OAuth authentication flow, taking care of getting the access token for HTTP requests.
 *
 *  @param clientID     The client ID provided during application signup.
 *  @param clientSecret The client secret provided during application signup.
 *  @param completion   The session completion block.
 */
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret completion:(UPPlatformSessionCompletion)completion;

/**
 *  Starts a user's session.
 *
 *  This will present a UIWebView to perform the OAuth authentication flow, taking care of getting the access token for HTTP requests.
 *
 *  @param clientID     The client ID provided during application signup.
 *  @param clientSecret The client secret provided during application signup.
 *  @param authScope    Options to request specific auth scopes during authentication. Defaults to UPPlatformAuthScopeBasicRead.
 *  @param completion   The session completion block.
 */
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion;

/**
 *  Starts a user's session.
 *
 *  This will present a UIWebView to perform the OAuth authentication flow, taking care of getting the access token for HTTP requests.
 *
 *  @param clientID     The client ID provided during application signup.
 *  @param clientSecret The client secret provided during application signup.
 *  @param authScope    Options to request specific auth scopes during authentication. Defaults to UPPlatformAuthScopeBasicRead.
 *  @param redirectURI  An alternate redirect URI used during authentication. This is not common.
 *  @param completion   The session completion block.
 */
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret authScope:(UPPlatformAuthScope)authScope redirectURI:(NSString *)redirectURI completion:(UPPlatformSessionCompletion)completion;

#endif

/**
 *  Ends the current session, clearing the session and access token.
 */
- (void)endCurrentSession;

/**
 *  Sends an HTTP request, setting appropriate authentication headers based on the current session.
 *
 *  @param request    The request to send.
 *  @param completion The request completion block after receiving a response or error.
 */
- (void)sendRequest:(UPURLRequest *)request completion:(UPPlatformRequestCompletion)completion;

@end
