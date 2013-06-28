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

#if !(TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR)
@interface UPPlatform () <UPAuthViewControllerDelegate>
#else
@interface UPPlatform () <NSWindowDelegate>
#endif

@property (nonatomic, readwrite, strong) UPSession *currentSession;

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;

@property (nonatomic, copy) UPPlatformSessionCompletion sessionCompletion;

#if !(TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR)
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

+ (NSBundle *)platformBundle
{
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"UPPlatformSDK" withExtension:@"bundle"]];
}

#pragma mark - Auth Flow

- (NSString *)existingAuthToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.jawbone.up.authtoken"];
}

- (void)setExistingAuthToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"com.jawbone.up.authtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            
            self.currentSession.currentUser = user;
            if (completion) completion(self.currentSession, error);
        }];
    }
}

#if TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR

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
    
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/auth?response_type=code&client_id=%@&scope=%@&redirect_uri=%@", [UPPlatform basePlatformURL], self.clientID, [self stringFromAuthScope:authScope], @"up-platform://redirect"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURLString]];
	request.HTTPShouldHandleCookies = NO;
	[webView setFrameLoadDelegate:self];
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
				
				[self setExistingAuthToken:authToken];
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
    
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/auth?response_type=code&client_id=%@&scope=%@&redirect_uri=%@", [UPPlatform basePlatformURL], self.clientID, [self stringFromAuthScope:authScope], @"up-platform://redirect"];
    
    self.authViewController = [[UPAuthViewController alloc] initWithURL:[NSURL URLWithString:authURLString] delegate:self];
    [self.authViewController show];
}

#endif

- (void)endCurrentSession
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.jawbone.up.authtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

#if !(TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR)

- (void)authViewController:(UPAuthViewController *)viewController didCompleteWithAuthCode:(NSString *)code
{
    // Use the auth code to get an auth token
    NSMutableString *authURLString = [NSMutableString stringWithFormat:@"%@/auth/oauth2/token?grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@", [UPPlatform basePlatformURL], self.clientID, self.clientSecret, code];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authURLString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error == nil && data.length)
        {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *authToken = responseJSON[@"access_token"];
            
            [self setExistingAuthToken:authToken];
            self.currentSession = [[UPSession alloc] initWithToken:authToken];
            self.sessionCompletion(self.currentSession, nil);
        }
        else
        {
            self.sessionCompletion(nil, error);
        }
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
