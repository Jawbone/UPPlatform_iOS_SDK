//
//  UPWorkoutAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPWorkoutAPI.h"

#import "UPURLRequest.h"
#import "UPPlatform.h"
#import "UPURLResponse.h"
#import "NSDictionary+UPPlatform.h"

static NSString *kWorkoutType = @"workouts";

@implementation UPWorkoutAPI

+ (void)getWorkoutsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion
{
	if (limit == 0) limit = 10;
	NSDictionary *params = @{ @"limit" : @(limit) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/workouts", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPWorkout *workout = [[UPWorkout alloc] init];
				[workout decodeFromDictionary:jsonItem];
				
				[results addObject:workout];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)getWorkoutsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion
{
	NSDictionary *params = @{ @"start_time" : @([startDate timeIntervalSince1970]), @"end_time" : @([endDate timeIntervalSince1970]) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/workouts", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPWorkout *workout = [[UPWorkout alloc] init];
				[workout decodeFromDictionary:jsonItem];
				
				[results addObject:workout];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)postWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion
{
	[UPBaseEventAPI postEvent:workout completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(workout, response, error);
	}];
}

+ (void)refreshWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:workout completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(workout, response, error);
	}];
}

+ (void)deleteWorkout:(UPWorkout *)workout completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:workout completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)getWorkoutGraphImage:(UPWorkout *)workout completion:(UPBaseEventAPIImageCompletion)completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:workout.graphImageURL]];
		
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

+ (void)getWorkoutTicks:(UPWorkout *)workout completion:(UPBaseEventAPIArrayCompletion)completion
{
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/workouts/%@/ticks", [UPPlatform currentPlatformVersion], workout.xid] params:nil];
	[[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *ticks = [NSMutableArray array];
		if (error == nil)
		{
			NSArray *data = response.data[@"items"];
			for (NSDictionary *tickJSON in data)
            {
                UPMoveTick *tick = [[UPMoveTick alloc] init];
                [tick decodeFromDictionary:tickJSON];
                [ticks addObject:tick];
            }
		}
		
		if (completion) completion(ticks, response, error);
	}];
}

@end

@implementation UPWorkout

+ (UPWorkout *)workoutWithType:(UPWorkoutType)type startTime:(NSDate *)startTime endTime:(NSDate *)endTime intensity:(UPWorkoutIntensity)intensity caloriesBurned:(NSNumber *)caloriesBurned
{
	UPWorkout *workout = [[UPWorkout alloc] init];
	
	workout.title = @"";
	workout.type = type;
	workout.timeCreated = startTime;
	workout.timeCompleted = endTime;
	workout.intensity = intensity;
	workout.totalCalories = caloriesBurned;
	
	return workout;
}

- (NSString *)apiType
{
	return kWorkoutType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	// These values are a bit different than UPMove
	NSDictionary *details = dictionary[@"details"];
	self.activeTime = [details numberForKey:@"bg_active_time"];
	self.activeCalories = [details numberForKey:@"bg_calories"];
	self.totalCalories = [details numberForKey:@"calories"];
	
	self.timeCompleted = [NSDate dateWithTimeIntervalSince1970:[[dictionary numberForKey:@"time_completed"] doubleValue]];
	self.intensity = [[details numberForKey:@"intensity"] intValue];
	if ([dictionary stringForKey:@"route"].length > 0) self.routeImageURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"route"]];
	if ([dictionary stringForKey:@"image"].length > 0) self.imageURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"image"]];
	self.type = [[dictionary numberForKey:@"sub_type"] intValue];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.intensity != 0) [dict setObject:@(self.intensity) forKey:@"intensity"];
	if (self.type != 0) [dict setObject:@(self.type) forKey:@"sub_type"];
	if (self.totalCalories != nil) [dict setObject:self.totalCalories forKey:@"calories"];
	if (self.imageURL != nil) [dict setObject:self.imageURL forKey:@"image_url"];
	if (self.timeCompleted) [dict setObject:@([self.timeCompleted timeIntervalSince1970]) forKey:@"time_completed"];
	if (self.distance) [dict setObject:@([self.distance floatValue] * 1000 ) forKey:@"distance"];
	
	return dict;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPWorkout: { xid: %@, title: %@, date: %@, type: %d, intensity: %d, activeTime: %@, inactiveTime: %@, restingCalories: %@, activeCalories: %@, totalCalories: %@, distance: %@, steps: %@, longestIdle: %@, longestActive: %@, imageURL: %@ }", self.xid, self.title, self.date, (int)self.type, (int)self.intensity, self.activeTime, self.inactiveTime, self.restingCalories, self.activeCalories, self.totalCalories, self.distance, self.steps, self.longestIdle, self.longestActive, self.imageURL];
}

@end