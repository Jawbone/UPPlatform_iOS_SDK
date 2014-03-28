//
//  NSDate+UPPlatform.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Date helper methods.
 */
@interface NSDate (UPPlatform)

/**
 *  Creates a date object from a day integer (i.e. 20140215)
 *
 *  @param dayInt   The day integer to convert to a date.
 *  @param timezone The timezone used to convert the date.
 */
+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt inTimeZone:(NSTimeZone*)timezone;

/**
 *  Creates a date object from a day integer in the user's local timezone. (i.e. 20140215)
 *
 *  @param dayInt The day integer to convert to a date.
 */
+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt;

/**
 *  The current date represented as a day integer string.
 */
- (NSString *)dayIntString;

@end
