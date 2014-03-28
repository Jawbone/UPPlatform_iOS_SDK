//
//  UPURLResponse.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The base response object for all HTTP requests.
 */
@interface UPURLResponse : NSObject

- (id)initWithCode:(NSInteger)code data:(NSDictionary *)data metadata:(NSDictionary *)metadata nextPageURL:(NSString *)nextPageURL;

/**
 *  The HTTP status code of the response.
 */
@property (nonatomic, readonly) NSInteger code;

/**
 *  A dictionary with the contents of the response.
 */
@property (nonatomic, readonly) NSDictionary *data;

/**
 *  A dictinoary with the metadata of the response.
 */
@property (nonatomic, readonly) NSDictionary *metadata;

/**
 *  The next page URL used in paginated responses.
 */
@property (nonatomic, readonly) NSString *nextPageURL;

@end
