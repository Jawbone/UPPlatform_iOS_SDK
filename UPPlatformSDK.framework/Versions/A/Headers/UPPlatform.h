//
//  UPManager.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPSession, UPURLRequest, UPURLResponse;

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

typedef void(^UPPlatformSessionCompletion)(UPSession *session, NSError *error);
typedef void(^UPPlatformRequestCompletion)(UPURLRequest *request, UPURLResponse *response, NSError *error);

@interface UPPlatform : NSObject

@property (nonatomic, readonly) UPSession *currentSession;
@property (nonatomic, assign) BOOL enableNetworkLogging;

+ (UPPlatform *)sharedPlatform;
+ (NSString *)basePlatformURL;
+ (NSBundle *)platformBundle;

- (void)validateSessionWithCompletion:(UPPlatformSessionCompletion)completion;

#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView completion:(UPPlatformSessionCompletion)completion;
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret webView:(WebView *)webView authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion;
#else
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret completion:(UPPlatformSessionCompletion)completion;
- (void)startSessionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret authScope:(UPPlatformAuthScope)authScope completion:(UPPlatformSessionCompletion)completion;
#endif

- (void)endCurrentSession;

- (void)sendRequest:(UPURLRequest *)request completion:(UPPlatformRequestCompletion)completion;

@end
