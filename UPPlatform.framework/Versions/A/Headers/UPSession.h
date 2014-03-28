//
//  UPSession.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPUser;

/**
 *  Represents an authenticated user's active session.
 */
@interface UPSession : NSObject

/**
 *  Creates a new session with a given access token.
 *
 *  @param token The access token received during OAuth.
 */
- (id)initWithToken:(NSString *)token;

/**
 *  The authentication token of the current session, used for all HTTP requests.
 */
@property (nonatomic, readonly) NSString *authenticationToken;

/**
 *  The currently authenticated user.
 */
@property (nonatomic, strong) UPUser *currentUser;

@end
