//
//  UPSleepAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPSleepAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"
#import "NSDictionary+UPPlatform.h"

static NSString *kSleepType = @"sleeps";

@implementation UPSleepAPI

+ (void)getSleepsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion
{
	if (limit == 0) limit = 10;
	NSDictionary *params = @{ @"limit" : @(limit) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me/sleeps" params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPSleep *sleep = [[UPSleep alloc] init];
				[sleep decodeFromDictionary:jsonItem];
				
				[results addObject:sleep];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)getSleepsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion
{
	NSDictionary *params = @{ @"start_time" : @([startDate timeIntervalSince1970]), @"end_time" : @([endDate timeIntervalSince1970]) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me/sleeps" params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPSleep *sleep = [[UPSleep alloc] init];
				[sleep decodeFromDictionary:jsonItem];
				
				[results addObject:sleep];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)postSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion
{
	[UPBaseEventAPI postEvent:sleep completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(sleep, response, error);
	}];
}

+ (void)refreshSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:sleep completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(sleep, response, error);
	}];
}

+ (void)deleteSleep:(UPSleep *)sleep completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:sleep completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)getSleepGraphImage:(UPSleep *)sleep completion:(UPBaseEventAPIImageCompletion)completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sleep.graphImageURL]];
		
#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
		NSImage *image = [[NSImage alloc] initWithData:imageData];
#else
		UIImage *image = [UIImage imageWithData:imageData];
#endif
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completion != nil) completion(image);
		});
	});
}

+ (void)getSleepSnapshot:(UPSleep *)sleep completion:(UPBaseEventAPISnapshotCompletion)completion
{
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/sleeps/%@/snapshot", sleep.xid] params:nil];
	[[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		UPSnapshot *snapshot = nil;
		if (error == nil)
		{
			NSArray *data = (NSArray *)response.data;
			snapshot = [UPSnapshot snapshotWithArray:data];
		}
		
		if (completion) completion(snapshot, response, error);
	}];
}

@end

@implementation UPSleep

+ (UPSleep *)sleepWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
	UPSleep *sleep = [[UPSleep alloc] init];
	
	sleep.title = @"";
	sleep.timeCreated = startTime;
	sleep.timeCompleted = endTime;
	
	return sleep;
}

- (NSString *)apiType
{
	return kSleepType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	// These values are a bit different than UPMove
	NSDictionary *details = dictionary[@"details"];
	self.asleepTime = [NSDate dateWithTimeIntervalSince1970:[[details numberForKey:@"asleep_time"] doubleValue]];
	self.awakeTime = [NSDate dateWithTimeIntervalSince1970:[[details numberForKey:@"awake_time"] doubleValue]];
	self.totalTimeAwake = [details numberForKey:@"awake"];
	self.totalTimeDeep = [details numberForKey:@"deep"];
	self.totalTimeLight = [details numberForKey:@"light"];
	self.totalTime = [details numberForKey:@"duration"];
	self.quality = [details numberForKey:@"quality"];
	self.awakenings = [details numberForKey:@"awakenings"];
	if ([[details numberForKey:@"smart_alarm_fire"] intValue] > 0) self.smartAlarmFireTime = [NSDate dateWithTimeIntervalSince1970:[[details numberForKey:@"smart_alarm_fire"] doubleValue]];
	
	self.timeCompleted = [NSDate dateWithTimeIntervalSince1970:[[dictionary numberForKey:@"time_completed"] doubleValue]];
	if ([dictionary stringForKey:@"snapshot_image"].length > 0) self.graphImageURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"snapshot_image"]];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.timeCompleted != nil) [dict setObject:@([self.timeCompleted timeIntervalSince1970]) forKey:@"time_completed"];
	
	return dict;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPSleep: { xid: %@, title: %@, date: %@, asleepTime: %@, awakeTime: %@, totalTimeAwake: %@, totalTimeDeep: %@, totalTimeLight: %@, totalTime: %@, quality: %@, awakenings: %@, smartAlarmFireTime: %@, graphImageURL: %@ }", self.xid, self.title, self.date, self.asleepTime, self.awakeTime, self.totalTimeAwake, self.totalTimeDeep, self.totalTimeLight, self.totalTime, self.quality, self.awakenings, self.smartAlarmFireTime, self.graphImageURL];
}

@end
