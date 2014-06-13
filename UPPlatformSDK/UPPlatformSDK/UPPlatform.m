//
//  UPManager.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPPlatform.h"

#import "UPAuthViewController.h"
#import "UPSession.h"
#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPUserAPI.h"

NSString * const kUPPlatformDefaultRedirectURI      = @"up-platform://redirect";
NSString * const kUPKeychainAccountKey              = @"com.jawbone.up";
NSString * const kUPKeychainTokenServiceKey         = @"com.jawbone.up.api_token";
NSString * const kUPKeychainRefreshTokenServiceKey  = @"com.jawbone.up.refresh_token";

#pragma mark - Keychain

@interface UPKeychain : NSObject

+ (NSString *)keychainItemForService:(NSString *)serviceKey;
+ (void)setKeychainItem:(NSString *)item forServiceKey:(NSString *)serviceKey;

@end

#pragma mark - Platform

#if !UP_TARGET_OSX
@interface UPPlatform () <UPAuthViewControllerDelegate>
#else
@interface UPPlatform () <NSWindowDelegate>
#endif

@property (nonatomic, readwrite, strong) UPSession *currentSession;

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, copy) UPPlatformSessionCompletion sessionCompletion;

#if !UP_TARGET_OSX
@property (nonatomic, strong) UPAuthViewController *authViewController;
#else
@property (nonatomic, strong) NSWindow *authWindow;
#endif

@end

@implementation UPPlatform

#pragma mark - Initialization

static UPPlatform *_instance = nil;

+ (UPPlatform *)sharedPlatform
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UPPlatform alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *token = [self existingAuthToken];
        if (token != nil)
        {
            self.currentSession = [[UPSession alloc] initWithToken:token];
        }
    }
    
    return self;
}

+ (NSString *)basePlatformURL
{
    return @"https://jawbone.com";
}

+ (NSString *)currentPlatformVersion
{
    return @"v.1.1";
}

#pragma mark - Auth Flow

- (NSString *)existingAuthToken
{
    return [UPKeychain keychainItemForService:kUPKeychainTokenServiceKey];
}

- (void)setExistingAuthToken:(NSString *)token
{
    [UPKeychain setKeychainItem:token forServiceKey:kUPKeychainTokenServiceKey];
}

- (NSString *)refreshToken
{
    return [UPKeychain keychainItemForService:kUPKeychainRefreshTokenServiceKey];
}

- (void)setRefreshToken:(NSString *)token
{
    [UPKeychain setKeychainItem:token forServiceKey:kUPKeychainRefreshTokenServiceKey];
}

- (void)validateSessionWithCompletion:(UPPlatformSessionCompletion)completion
{
    if (self.currentSession == nil)
    {
        NSError *error = [NSError errorWithDomain:@"com.jawbone.up" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"No current session" }];
        if (completion) completion(nil, error);
    }
    else
    {
        [UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
            if (response.code == 401)
            {
                [self endCurrentSession];
            }
            else if (user != nil)
            {
                self.currentSession.currentUser = user;
            }
            
            if (completion) completion(self.currentSession, error);
        }];
    }
}

- (void)refreshAccessTokenWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret completion:(UPPlatformSessionCompletion)completion
{
    NSString *refreshToken = [self refreshToken];
    
    if (refreshToken == nil)
    {
        NSError *error = [NSError errorWithDomain:@"com.jawbone.up" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"No refresh token found. Cannot refresh the current access token." }];
        if (completion) completion(nil, error);
        return;
    }
    
    NSDictionary *params = @{ @"grant_type" : @"refresh_token", @"refresh_token" : refreshToken, @"client_id" : clientID, @"client_secret" : clientSecret };
    NSString *refreshURLString = [NSString stringWithFormat:@"%@/auth/oauth2/token", [UPPlatform basePlatformURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:refreshURLString]];
    request.HTTPMethod = @"post";
    
    NSMutableArray *paramStrings = [NSMutableArray array];
    for (NSString *key in params.allKeys)
    {
        [paramStrings addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
    }
    
    NSString *fullParamString = [paramStrings componentsJoinedByString:@";"];
    request.HTTPBody = [fullParamString dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error == nil && data.length)
        {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *authToken = responseJSON[@"access_token"];
            NSString *refreshToken = responseJSON[@"refresh_token"];
            
            [self setExistingAuthToken:authToken];
            [self setRefreshToken:refreshToken];
            
            self.currentSession = [[UPSession alloc] initWithToken:authToken];
            completion(self.currentSession, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

#if UP_TARGET_OSX

- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView completion:(UPPlatformSessionCompletion)completion
{
	[self startSessionWithClientID:clientID clientSecret:clientSecret webView:webView authScope:UPPlatformAuthScopeBasicRead completion:completion];
}

- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion
{
	self.sessionCompletion = completion;
    self.clientID = clientID;
    self.clientSecret = clientSecret;
    
    NSString *token = [self existingAuthToken];
    if (token != nil)
    {
        self.currentSession = [[UPSession alloc] initWithToken:token];
        self.sessionCompletion(self.currentSession, nil);
        return;
    }
    
    if (webView == nil)
    {
        webView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 320, 480) frameName:nil groupName:nil];
        self.authWindow = [[NSWindow alloc] initWithContentRect:webView.bounds styleMask:NSTitledWindowMask | NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen]];
        self.authWindow.delegate = self;
        [self.authWindow setReleasedWhenClosed:NO];
        
        NSArray *windows = [NSApplication sharedApplication].windows;
        NSRect keyWindowFrame = ((NSWindow *)windows[0]).frame;
        NSRect windowFrame = NSMakeRect(keyWindowFrame.origin.x, keyWindowFrame.origin.y, 320, 480);
        [self.authWindow setFrame:windowFrame display:YES];
        [self.authWindow setContentView:webView];
        [self.authWindow makeKeyAndOrderFront:nil];
    }
    
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/auth?response_type=code&client_id=%@&scope=%@&redirect_uri=%@", [UPPlatform basePlatformURL], self.clientID, [self stringFromAuthScope:authScope], kUPPlatformDefaultRedirectURI];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURLString]];
	request.HTTPShouldHandleCookies = NO;
	[webView setFrameLoadDelegate:self];
    [webView setPolicyDelegate:self];
	[webView.mainFrame loadRequest:request];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	// The up-platform URL scheme will cause this error. We'll catch it and use the code to grab a session token
	NSURLRequest *request = frame.provisionalDataSource.request;
	
	if ([request.URL.scheme isEqualToString:@"up-platform"])
    {
        NSString *query = request.URL.query;
        NSString *code = [query stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        
		// Use the auth code to get an auth token
		NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/token?grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@", [UPPlatform basePlatformURL], self.clientID, self.clientSecret, code];
		
		[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authURLString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            [self.authWindow close];
            self.authWindow = nil;
            
			if (error == nil && data.length)
			{
				NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				NSString *authToken = responseJSON[@"access_token"];
                NSString *refreshToken = responseJSON[@"refresh_token"];
				
				[self setExistingAuthToken:authToken];
                [self setRefreshToken:refreshToken];
                
				self.currentSession = [[UPSession alloc] initWithToken:authToken];
				self.sessionCompletion(self.currentSession, nil);
			}
            else
            {
                self.sessionCompletion(nil, error);
            }
		}];
    }
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(WebFrame *)frame
decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if ([request.URL.scheme isEqualToString:@"up-platform"])
    {
        [listener ignore];
    }
    else
    {
        [listener use];
    }
}

- (BOOL)windowShouldClose:(id)sender
{
    self.authWindow = nil;
    self.sessionCompletion(nil, [NSError errorWithDomain:@"com.jawbone.up" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Authentication canceled by user." }]);
    
    return YES;
}

#else

- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret completion:(UPPlatformSessionCompletion)completion
{
    [self startSessionWithClientID:clientID clientSecret:clientSecret authScope:UPPlatformAuthScopeBasicRead completion:completion];
}

- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion
{
    [self startSessionWithClientID:clientID clientSecret:clientSecret authScope:authScope redirectURI:kUPPlatformDefaultRedirectURI completion:completion];
}

- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret authScope:(UPPlatformAuthScope)authScope redirectURI:(NSString *)redirectURI completion:(UPPlatformSessionCompletion)completion
{
    self.sessionCompletion = completion;
    self.clientID = clientID;
    self.clientSecret = clientSecret;
    
    NSString *token = [self existingAuthToken];
    if (token != nil)
    {
        self.currentSession = [[UPSession alloc] initWithToken:token];
        
        [UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
            if (user != nil)
            {
                self.currentSession.currentUser = user;
            }
            
            self.sessionCompletion(self.currentSession, nil);
        }];
        
        return;
    }
    
    self.redirectURI = redirectURI;
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/auth?response_type=code&client_id=%@&scope=%@&redirect_uri=%@", [UPPlatform basePlatformURL], self.clientID, [self stringFromAuthScope:authScope], redirectURI];
    
    self.authViewController = [[UPAuthViewController alloc] initWithURL:[NSURL URLWithString:authURLString] delegate:self];
    [self.authViewController show];
}

#endif

- (void)endCurrentSession
{
    [UPKeychain setKeychainItem:@"" forServiceKey:kUPKeychainTokenServiceKey];
    [UPKeychain setKeychainItem:@"" forServiceKey:kUPKeychainRefreshTokenServiceKey];
    
    self.currentSession = nil;
}

- (NSString *)stringFromAuthScope:(UPPlatformAuthScope)scope
{
    NSMutableArray *scopeStrings = [NSMutableArray array];
    
    if (scope & UPPlatformAuthScopeBasicRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"basic_read"];
    if (scope & UPPlatformAuthScopeExtendedRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"extended_read"];
    if (scope & UPPlatformAuthScopeLocationRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"location_read"];
    if (scope & UPPlatformAuthScopeFriendsRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"friends_read"];
    if (scope & UPPlatformAuthScopeMoodRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"mood_read"];
    if (scope & UPPlatformAuthScopeMoodWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"mood_write"];
    if (scope & UPPlatformAuthScopeMoveRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"move_read"];
    if (scope & UPPlatformAuthScopeMoveWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"move_write"];
    if (scope & UPPlatformAuthScopeSleepRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"sleep_read"];
	if (scope & UPPlatformAuthScopeSleepWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"sleep_write"];
    if (scope & UPPlatformAuthScopeMealRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"meal_read"];
    if (scope & UPPlatformAuthScopeMealWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"meal_write"];
    if (scope & UPPlatformAuthScopeWeightRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"weight_read"];
    if (scope & UPPlatformAuthScopeWeightWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"weight_write"];
    if (scope & UPPlatformAuthScopeCardiacRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"cardiac_read"];
    if (scope & UPPlatformAuthScopeCardiacWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"cardiac_write"];
    if (scope & UPPlatformAuthScopeGenericRead || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"generic_event_read"];
    if (scope & UPPlatformAuthScopeGenericWrite || scope & UPPlatformAuthScopeAll) [scopeStrings addObject:@"generic_event_write"];
    
    return [scopeStrings componentsJoinedByString:@"%20"];
}

#pragma mark - Auth View Controller Delegate

#if !UP_TARGET_OSX

- (void)authViewController:(UPAuthViewController *)viewController didCompleteWithAuthCode:(NSString *)code
{
    // Use the auth code to get an auth token
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/token?grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@", [UPPlatform basePlatformURL], self.clientID, self.clientSecret, code];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authURLString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error == nil && data.length)
        {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *jsonError = responseJSON[@"error"];
            if (jsonError.length == 0)
            {
                NSString *authToken = responseJSON[@"access_token"];
                NSString *refreshToken = responseJSON[@"refresh_token"];
                
                [self setExistingAuthToken:authToken];
                [self setRefreshToken:refreshToken];
                
                self.currentSession = [[UPSession alloc] initWithToken:authToken];
                
                [UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
                    if (user != nil)
                    {
                        self.currentSession.currentUser = user;
                    }
                    
                    self.sessionCompletion(self.currentSession, nil);
                }];
            }
            else
            {
                NSString *errorDescription = responseJSON[@"error_description"];
                self.sessionCompletion(nil, [NSError errorWithDomain:@"com.jawbone.up" code:0 userInfo:@{ NSLocalizedDescriptionKey : errorDescription }]);
            }
        }
        else
        {
            self.sessionCompletion(nil, error);
        }
        
        self.authViewController = nil;
    }];
}

- (void)authViewController:(UPAuthViewController *)viewController didFailWithError:(NSError *)error
{
    if (error.code != 102 && error.code != 101)
    {
        self.authViewController = nil;
        self.sessionCompletion(nil, error);
    }
}

- (void)authViewControllerDidCancel:(UPAuthViewController *)viewController
{
    self.authViewController = nil;
    self.sessionCompletion(nil, [NSError errorWithDomain:@"com.jawbone.up" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Authentication canceled by user." }]);
}

#endif

#pragma mark - Network Requests

- (void)sendRequest:(UPURLRequest *)request completion:(UPPlatformRequestCompletion)completion
{
    if (self.enableNetworkLogging)
    {
        NSString *bodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if (bodyString.length == 0) bodyString = @"{}";
        
        NSLog(@"[UPPlatform request] : [%@] : \n%@", request.URL.absoluteString, bodyString);
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (self.enableNetworkLogging)
        {
            NSLog(@"[UPPlatform response] : [%@] : \n%@", request.URL.absoluteString, jsonResponse);
        }
		
		NSString *next = [jsonResponse[@"data"] isKindOfClass:[NSDictionary class]] ? jsonResponse[@"data"][@"links"][@"next"] : nil;
        UPURLResponse *response = [[UPURLResponse alloc] initWithCode:[jsonResponse[@"meta"][@"code"] intValue] data:jsonResponse[@"data"] metadata:jsonResponse[@"meta"] nextPageURL:next];
        
        if (!error || response.metadata != nil)
        {
            NSError *apiError = nil;
            NSString *errorDetail = response.metadata[@"error_detail"];
            if (errorDetail.length)
            {
                NSString *code = response.metadata[@"code"];
                apiError = [NSError errorWithDomain:@"com.jawbone.up" code:[code intValue] userInfo:@{ NSLocalizedDescriptionKey : errorDetail }];
            }
                                           
            if (completion != nil) completion(request, response, apiError);
        }
		else if ([self responseDidFail:response])
		{
			NSError *apiError = nil;
            NSString *errorDetail = response.metadata[@"message"];
			NSString *code = response.metadata[@"code"];
			apiError = [NSError errorWithDomain:@"com.jawbone.up" code:[code intValue] userInfo:@{ NSLocalizedDescriptionKey : errorDetail }];
			
			if (completion != nil) completion(request, response, apiError);
		}
        else
        {
            if (completion != nil) completion(request, nil, error);
        }
    }];
}

- (BOOL)responseDidFail:(UPURLResponse *)response
{
	return response.code == 500;
}

@end

@implementation UPKeychain

+ (NSString *)keychainItemForService:(NSString *)serviceKey
{
    return [self keychainItemForService:serviceKey returnNilIfEmpty:YES];
}

+ (NSString *)keychainItemForService:(NSString *)serviceKey returnNilIfEmpty:(BOOL)returnNilIfEmpty
{
    id account = kUPKeychainAccountKey;
    id service = serviceKey;
    
#if !UP_TARGET_OSX
    account = [account dataUsingEncoding:NSUTF8StringEncoding];
    service = [service dataUsingEncoding:NSUTF8StringEncoding];
#endif
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    dictionary[(__bridge id)kSecAttrAccount] = account;
    dictionary[(__bridge id)kSecAttrService] = service;
    dictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    dictionary[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    
    CFTypeRef cfResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary, &cfResult);
    
    if (status == errSecSuccess && cfResult != NULL)
    {
        NSData *result = (__bridge_transfer NSData *)cfResult;
        NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        if (returnNilIfEmpty)
        {
            return resultString.length > 0 ? resultString : nil;
        }
        
        return resultString;
    }
    
    return nil;
}

+ (void)setKeychainItem:(NSString *)item forServiceKey:(NSString *)serviceKey
{
    id account = kUPKeychainAccountKey;
    id service = serviceKey;
    
#if !UP_TARGET_OSX
    account = [account dataUsingEncoding:NSUTF8StringEncoding];
    service = [service dataUsingEncoding:NSUTF8StringEncoding];
#endif
    
    NSMutableDictionary *existingItemDictionary = [NSMutableDictionary dictionary];
    
    existingItemDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    existingItemDictionary[(__bridge id)kSecAttrAccount] = account;
    existingItemDictionary[(__bridge id)kSecAttrService] = service;
    
    NSString *oldItem = [self keychainItemForService:serviceKey returnNilIfEmpty:NO];
    if (item == nil)
    {
        if (oldItem != nil)
        {
            SecItemDelete((__bridge CFDictionaryRef)existingItemDictionary);
        }
    }
    else
    {
        NSData *itemData = [item dataUsingEncoding:NSUTF8StringEncoding];
        if (oldItem != nil)
        {
            NSMutableDictionary *updateDictionary = [NSMutableDictionary dictionary];
            updateDictionary[(__bridge id)kSecValueData] = itemData;
            (void)SecItemUpdate((__bridge CFDictionaryRef)existingItemDictionary, (__bridge CFDictionaryRef)updateDictionary);
        }
        else
        {
            existingItemDictionary[(__bridge id)kSecValueData] = itemData;
            (void)SecItemAdd((__bridge CFDictionaryRef)existingItemDictionary, NULL);
        }
    }
}

@end
