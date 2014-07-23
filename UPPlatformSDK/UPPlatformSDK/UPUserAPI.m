//
//  UPUserAPI.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPUserAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"
#import "NSDate+UPPlatform.h"
#import "NSDictionary+UPPlatform.h"

@implementation UPUserAPI

+ (void)getCurrentUserWithCompletion:(UPUserAPICompletion)completion
{
    UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me", [UPPlatform currentPlatformVersion]] params:nil];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        
        UPUser *user = nil;
        if (!error)
        {
            user = [[UPUser alloc] init];
            [user decodeFromDictionary:response.data];
        }
        
        if (completion != nil) completion(user, response, error);
    }];
}

+ (void)getFriendsWithCompletion:(UPBaseEventAPIArrayCompletion)completion
{
    UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/friends", [UPPlatform currentPlatformVersion]] params:nil];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        NSMutableArray *results = [NSMutableArray array];
        NSArray *jsonItems = response.data[@"items"];
        for (NSDictionary *jsonItem in jsonItems)
        {
            UPUser *friend = [[UPUser alloc] init];
            [friend decodeFromDictionary:jsonItem];
            [results addObject:friend];
        }
        
        if (completion != nil) completion(results, response, error);
    }];
}

+ (void)getTrendsWithEndDate:(NSDate *)endDate rangeType:(UPUserTrendsRangeType)rangeType rangeDuration:(NSUInteger)rangeDuration bucketSize:(UPUserTrendsBucketSize)bucketSize completion:(UPUserTrendsAPICompletion)completion
{
	NSString *dateString = [endDate dayIntString];
	
	NSString *range = nil;
	switch (rangeType)
	{
		case UPUserTrendsRangeTypeDays:
			range = @"d";
			break;
			
		case UPUserTrendsRangeTypeWeeks:
			range = @"w";
			break;
			
		default:
			break;
	}
	
	NSString *bucket = nil;
	switch (bucketSize)
	{
		case UPUserTrendsBucketSizeDays:
			bucket = @"d";
			break;
			
		case UPUserTrendsBucketSizeWeeks:
			bucket = @"w";
			break;
			
		case UPUserTrendsBucketSizeMonths:
			bucket = @"m";
			break;
			
		case UPUserTrendsBucketSizeYears:
			bucket = @"y";
			break;
			
		default:
			break;
	}
	
	NSMutableDictionary *params = [@{ @"range_duration" : @(rangeDuration), @"range" : range, @"bucket_size" : bucket } mutableCopy];
	if (endDate != nil) [params setObject:dateString forKey:@"end_date"];
	
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/trends", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        NSMutableArray *results = [NSMutableArray array];
        NSArray *jsonItems = response.data[@"data"];
        for (NSArray *jsonItem in jsonItems)
        {
			UPTrend *trend = [[UPTrend alloc] init];
			[trend decodeFromDictionary:@{ @"array" : jsonItem }];

			[results addObject:trend];
        }
        
        if (completion != nil) completion(results, response, error);
    }];
}

+ (void)getUserGoalsWithCompletion:(UPUserGoalsAPICompletion)completion
{
    UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/goals", [UPPlatform currentPlatformVersion]] params:nil];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        
        UPUserGoals *goals = nil;
        if (!error)
        {
            goals = [[UPUserGoals alloc] init];
            [goals decodeFromDictionary:response.data];
        }
        
        if (completion != nil) completion(goals, response, error);
    }];
}

+ (void)getUserSharingSettingsWithCompletion:(UPUserSharingSettingsAPICompletion)completion
{
    UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/settings", [UPPlatform currentPlatformVersion]] params:nil];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        
        UPUserSharingSettings *settings = nil;
        if (!error)
        {
            settings = [[UPUserSharingSettings alloc] init];
            [settings decodeFromDictionary:response.data];
        }
        
        if (completion != nil) completion(settings, response, error);
    }];
}

@end

@implementation UPUser

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.xid = [dictionary stringForKey:@"xid"];
	self.firstName = [dictionary stringForKey:@"first"];
	self.lastName = [dictionary stringForKey:@"last"];
    self.weight = [dictionary numberForKey:@"weight"];
    self.height = [dictionary numberForKey:@"height"];
    self.gender = [[dictionary numberForKey:@"gender"] intValue] == 0 ? UPUserGenderMale : UPUserGenderFemale;
	if ([dictionary stringForKey:@"image"].length > 0) self.imageURL = [NSString stringWithFormat:@"%@/%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"image"]];
}

- (NSDictionary *)encodeToDictionary
{
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPUser: { xid: %@, firstName: %@, lastName: %@, imageURL: %@, weight: %@, height: %@, gender: %@ }", self.xid, self.firstName, self.lastName, self.imageURL, self.weight, self.height, self.gender == UPUserGenderMale ? @"Male" : @"Female"];
}

@end

@implementation UPUserGoals

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.moveSteps = [dictionary numberForKey:@"move_steps"];
	self.sleepTotal = [dictionary numberForKey:@"sleep_total"];
    self.bodyWeight = [dictionary numberForKey:@"body_weight"];
    self.eatSaturatedFat = [dictionary numberForKey:@"eat_sat_fat"];
    self.eatSodium = [dictionary numberForKey:@"eat_sodium"];
    self.eatCarbs = [dictionary numberForKey:@"eat_carbs"];
    self.eatCholesterol = [dictionary numberForKey:@"eat_cholesterol"];
    self.eatFiber = [dictionary numberForKey:@"eat_fiber"];
    self.eatProtein = [dictionary numberForKey:@"eat_protein"];
    self.eatCalcium = [dictionary numberForKey:@"eat_calcium"];
    self.eatSugar = [dictionary numberForKey:@"eat_sugar"];
    self.eatUnsaturatedFat = [dictionary numberForKey:@"eat_unsat_fat"];
}

- (NSDictionary *)encodeToDictionary
{
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPUserGoal: { moveSteps: %@, sleepTotal: %@, bodyWeight: %@, eatSaturatedFat: %@, eatSodium: %@, eatCarbs: %@, eatCholesterol: %@, eatFiber: %@, eatProtein: %@, eatCalcium: %@, eatSugar: %@, eatUnsaturatedFat: %@ }", self.moveSteps, self.sleepTotal, self.bodyWeight, self.eatSaturatedFat, self.eatSodium, self.eatCarbs, self.eatCholesterol, self.eatFiber, self.eatProtein, self.eatCalcium, self.eatSugar, self.eatUnsaturatedFat];
}

@end

@implementation UPUserSharingSettings

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.shareBody = [dictionary numberForKey:@"share_body"].boolValue;
	self.shareEat = [dictionary numberForKey:@"share_eat"].boolValue;
    self.shareMood = [dictionary numberForKey:@"share_mood"].boolValue;
    self.shareMove = [dictionary numberForKey:@"share_move"].boolValue;
    self.shareSleep = [dictionary numberForKey:@"share_sleep"].boolValue;
}

- (NSDictionary *)encodeToDictionary
{
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPUserSharingSettings: { shareBody: %d, shareEat: %d, shareMood: %d, shareMove: %d, shareSleep: %d }", self.shareBody, self.shareEat, self.shareMood, self.shareMove, self.shareSleep];
}

@end

@implementation UPTrend

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	NSArray *jsonArray = dictionary[@"array"];
	
	NSUInteger dateInt = [jsonArray[0] intValue];
	NSDictionary *values = jsonArray[1];
	
	self.date = [NSDate dateFromDayInt:dateInt];
	self.weight = [values numberForKey:@"weight"];
	self.height = [values numberForKey:@"height"];
	self.gender = [[values numberForKey:@"gender"] intValue] == 0 ? UPUserGenderMale : UPUserGenderFemale;
	self.age = [values numberForKey:@"age"];
	self.moveDistance = [values numberForKey:@"m_distance"];
	self.moveSteps = [values numberForKey:@"m_steps"];
	self.moveWorkoutTime = [values numberForKey:@"m_workout_time"];
	self.moveActiveTime = [values numberForKey:@"m_active_time"];
	self.moveCalories = [values numberForKey:@"m_calories"];
	self.sleepSound = [values numberForKey:@"s_sound"];
	self.sleepAwake = [values numberForKey:@"s_awake"];
	self.sleepTimeAsleep = [values numberForKey:@"s_asleep_time"];
	self.sleepTimeAwake = [values numberForKey:@"s_awake_time"];
	self.eatProtein = [values numberForKey:@"e_protein"];
	self.eatCalcium = [values numberForKey:@"e_calcium"];
	self.eatSaturatedFat = [values numberForKey:@"e_sat_fat"];
    self.eatUnsaturatedFat = [values numberForKey:@"e_unsat_fat"];
	self.eatCalories = [values numberForKey:@"e_calories"];
	self.eatSodium = [values numberForKey:@"e_sodium"];
	self.eatSugar = [values numberForKey:@"e_sugar"];
	self.eatCarbs = [values numberForKey:@"e_carbs"];
	self.eatFiber = [values numberForKey:@"e_fiber"];
}

- (NSDictionary *)encodeToDictionary
{
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPTrend: { date: %@, " \
			"weight: %@, " \
			"height: %@, " \
			"gender: %@, " \
			"age: %@, " \
			"moveDistance: %@, " \
			"moveSteps: %@, " \
			"moveWorkoutTime: %@, " \
			"moveActiveTime: %@, " \
			"moveCalories: %@, " \
			"sleepLight: %@, " \
			"sleepSound: %@, " \
			"sleepAwake: %@, " \
			"sleepTimeAsleep: %@, " \
			"sleepTimeAwake: %@, " \
			"eatProtein: %@, " \
			"eatCalcium: %@, " \
			"eatSaturatedFat: %@, " \
            "eatUnSaturatedFat: %@, " \
			"eatCalories: %@, " \
			"eatSodium: %@, " \
			"eatSugar: %@, " \
			"eatCarbs: %@, " \
			"eatFiber: %@, " \
			"}",
			self.date,
			self.weight,
			self.height,
			self.gender == UPUserGenderMale ? @"Male" : @"Female",
			self.age,
			self.moveDistance,
			self.moveSteps,
			self.moveWorkoutTime,
			self.moveActiveTime,
			self.moveCalories,
			self.sleepLight,
			self.sleepSound,
			self.sleepAwake,
			self.sleepTimeAsleep,
			self.sleepTimeAwake,
			self.eatProtein,
			self.eatCalcium,
			self.eatSaturatedFat,
            self.eatUnsaturatedFat,
			self.eatCalories,
			self.eatSodium,
			self.eatSugar,
			self.eatCarbs,
			self.eatFiber];
}

@end
