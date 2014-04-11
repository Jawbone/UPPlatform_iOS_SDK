//
//  UPSession.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPSession.h"

@interface UPSession ()

@property (nonatomic, readwrite, strong) NSString *authenticationToken;

@end

@implementation UPSession

- (id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self)
    {
        self.authenticationToken = token;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"UPSession: { authenticationToken: %@ }", self.authenticationToken];
}

@end
