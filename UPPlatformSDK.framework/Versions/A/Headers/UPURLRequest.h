//
//  UPURLRequest.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPURLRequest : NSMutableURLRequest

+ (UPURLRequest *)getRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;
+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;
+ (UPURLRequest *)deleteRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params;
+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params image:(UIImage *)image;

@end
