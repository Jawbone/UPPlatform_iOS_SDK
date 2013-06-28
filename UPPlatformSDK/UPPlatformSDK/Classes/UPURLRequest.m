//
//  UPURLRequest.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPURLRequest.h"

#import "UPPlatform.h"
#import "UPSession.h"

NSTimeInterval const kDefaultRequestTimeout     = 30.0;
NSString const *APIMultipartBoundary = @"t5abJf886c95bfexhOzryaoq2xuedO34ru8osiqbSrg9pqbeTf";

@interface UPURLRequest ()

@end

@implementation UPURLRequest

#pragma mark - Initialization

+ (UPURLRequest *)getRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params
{
    return [[UPURLRequest alloc] initWithEndpoint:endpoint params:params method:@"GET" image:nil];
}

+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params
{
    return [[UPURLRequest alloc] initWithEndpoint:endpoint params:params method:@"POST" image:nil];
}

+ (UPURLRequest *)postRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params image:(UPImage *)image
{
    return [[UPURLRequest alloc] initWithEndpoint:endpoint params:params method:@"POST" image:image];
}

+ (UPURLRequest *)deleteRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params
{
    return [[UPURLRequest alloc] initWithEndpoint:endpoint params:params method:@"DELETE" image:nil];
}

- (id)initWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params method:(NSString *)method image:(UPImage *)image
{
    NSAssert([UPPlatform sharedPlatform].currentSession != nil, @"Must have a valid session to create an UPURLRequest.");
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", [UPPlatform basePlatformURL], endpoint];
    self = [super initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kDefaultRequestTimeout];
    if (self)
    {
        BOOL isPost = [method isEqualToString:@"POST"];
        BOOL isMultipart = isPost && (image != nil);
        
        self.HTTPMethod = method;
        
        if (isMultipart)
        {
            NSMutableData *body = [NSMutableData data];
            
            for (NSString *key in params.allKeys)
            {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", APIMultipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", params[key]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            NSData *imageData = nil;
#if TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR
            //NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:(CGImageRef)image];
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)[image bestRepresentationForRect:NSMakeRect(0, 0, image.size.width, image.size.height) context:nil hints:nil];
            imageData = [bitmapRep representationUsingType:NSJPEGFileType properties:@{ NSImageCompressionFactor: @(1.0) }];
#else
            imageData = UIImageJPEGRepresentation(image, 1.0);
#endif
            if (imageData)
            {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", APIMultipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", APIMultipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            self.HTTPBody = body;
            [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
        }
        else if (isPost)
        {
            NSMutableArray *paramStrings = [NSMutableArray array];
            for (NSString *key in params.allKeys)
            {
                [paramStrings addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
            }
            
            NSString *fullParamString = [paramStrings componentsJoinedByString:@";"];
            
            self.HTTPBody = [fullParamString dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if (params != nil)
        {
            NSMutableArray *paramStrings = [NSMutableArray array];
            for (NSString *key in params.allKeys)
            {
                [paramStrings addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
            }
            
            NSString *fullParamString = [paramStrings componentsJoinedByString:@"&"];
			self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", self.URL.absoluteString, fullParamString]];
        }
        
        NSDictionary *headers = [self createRequestHeadersForPost:isPost isMultipart:isMultipart];
        for (NSString *key in headers.allKeys)
        {
            [self setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    return self;
}

#pragma mark - Request Setup

- (NSDictionary *)createRequestHeadersForPost:(BOOL)isPost isMultipart:(BOOL)isMultipart
{
    NSMutableDictionary *headers = [@{  @"Accept" : @"application/json",
                                        @"Authorization" : [NSString stringWithFormat:@"Bearer %@", [UPPlatform sharedPlatform].currentSession.authenticationToken]
                                        } mutableCopy];
    
    if (isMultipart)
    {
        NSDictionary *additionalHeaders = @{ @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", APIMultipartBoundary] };
        
        [headers addEntriesFromDictionary:additionalHeaders];
    }
    else if (isPost)
    {
        NSDictionary *additionalHeaders = @{ @"Content-Type" : @"application/x-www-form-urlencoded" };
        
        [headers addEntriesFromDictionary:additionalHeaders];
    }
    
    return headers;
}

@end
