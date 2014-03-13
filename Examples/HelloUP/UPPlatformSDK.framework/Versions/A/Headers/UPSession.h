//
//  UPSession.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPUser;

@interface UPSession : NSObject

- (id)initWithToken:(NSString *)token;

@property (nonatomic, readonly) NSString *authenticationToken;
@property (nonatomic, strong) UPUser *currentUser;

@end
