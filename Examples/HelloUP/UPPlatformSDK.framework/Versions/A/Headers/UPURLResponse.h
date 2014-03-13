//
//  UPURLResponse.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPURLResponse : NSObject

- (id)initWithCode:(NSInteger)code data:(NSDictionary *)data metadata:(NSDictionary *)metadata nextPageURL:(NSString *)nextPageURL;

@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, readonly) NSDictionary *data;
@property (nonatomic, readonly) NSDictionary *metadata;
@property (nonatomic, readonly) NSString *nextPageURL;

@end
