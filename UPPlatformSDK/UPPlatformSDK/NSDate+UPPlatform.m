//
//  NSDate+UPPlatform.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "NSDate+UPPlatform.h"

@implementation NSDate (UPPlatform)

+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt inTimeZone:(NSTimeZone*)timezone
{    
    if (dayInt == 0) return nil;
    
    int year = round(dayInt / 10000);
    int month = (dayInt % 10000) / 100;
    int day = dayInt % 100;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    comps.timeZone = timezone;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timezone;
    NSDate *date = [calendar dateFromComponents:comps];

    return date;
}

+ (NSDate *)dateFromDayInt:(NSUInteger)dayInt
{
	return [self dateFromDayInt:dayInt inTimeZone:[NSTimeZone localTimeZone]];
}

- (NSString *)dayIntString
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.timeZone = [NSTimeZone localTimeZone];
	
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSUInteger dayInt =  ([components year] * 10000) + ([components month] * 100) + [components day];
	
    return [NSString stringWithFormat:@"%lu", (unsigned long)dayInt];
}

@end
