//
//  UPURLResponse.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPURLResponse.h"

@interface UPURLResponse ()

@property (nonatomic, readwrite, assign) NSInteger code;
@property (nonatomic, readwrite, strong) NSDictionary *data;
@property (nonatomic, readwrite, strong) NSDictionary *metadata;
@property (nonatomic, readwrite, strong) NSString *nextPageURL;

@end

@implementation UPURLResponse

- (id)initWithCode:(NSInteger)code data:(NSDictionary *)data metadata:(NSDictionary *)metadata nextPageURL:(NSString *)nextPageURL
{
    self = [super init];
    if (self)
    {
        self.code = code;
        self.data = data;
        self.metadata = metadata;
		self.nextPageURL = nextPageURL;
    }
    
    return self;
}

@end
