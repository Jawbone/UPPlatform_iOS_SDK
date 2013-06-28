//
//  NSDictionary+UPPlatform.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "NSDictionary+UPPlatform.h"

@implementation NSDictionary (UPPlatform)

- (NSNumber *)numberForKey:(NSString *)key
{
	id number = self[key];
	if ([number isKindOfClass:[NSNumber class]])
	{
		return number;
	}
	
	return nil;
}

- (NSString *)stringForKey:(NSString *)key
{
	id string = self[key];
	if ([string isKindOfClass:[NSString class]])
	{
		return string;
	}
	
	return nil;
}

@end
