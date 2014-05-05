//
//  UPURLRequest.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPDefines.h"

/**
 *  The base URLRequest object that contains the necessary headers for OAuth.
 */
@interface UPURLRequest : NSMutableURLRequest

/**
 *  Creates a new GET request.
 *
 *  @param endpoint The endpoint to send the request, relative to the base platform URL (i.e. nudge/api/users/@me/meals)
 *  @param params   A dictionary of paramters to send with the request.
 */
+ (UPURLRequest *)getRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;

/**
 *  Creates a new POST request.
 *
 *  @param endpoint The endpoint to send the request, relative to the base platform URL (i.e. nudge/api/users/@me/meals)
 *  @param params   A dictionary of paramters to send with the request.
 */
+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;

/**
 *  Creates a new DELETE request.
 *
 *  @param endpoint The endpoint to send the request, relative to the base platform URL (i.e. nudge/api/users/@me/meals)
 *  @param params   A dictionary of paramters to send with the request.
 */
+ (UPURLRequest *)deleteRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;

/**
 *  Creates a new POST request with an additional image object.
 *
 *  @param endpoint The endpoint to send the request, relative to the base platform URL (i.e. nudge/api/users/@me/meals)
 *  @param params   A dictionary of paramters to send with the request.
 *  @param image    An image to post along with the params.
 */
+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params image:(UPImage *)image;

@end
