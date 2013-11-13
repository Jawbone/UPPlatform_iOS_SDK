//
//  NSDate+UPPlatform.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UPPlatform)

+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt inTimeZone:(NSTimeZone*)timezone;
+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt;
- (NSString *)dayIntString;

@end
