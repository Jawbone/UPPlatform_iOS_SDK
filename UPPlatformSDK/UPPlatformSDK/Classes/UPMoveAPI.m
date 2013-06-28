//
//  UPMoveAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPMoveAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"
#import "NSDictionary+UPPlatform.h"
#import "NSDate+UPPlatform.h"

static NSString *kMoveType = @"moves";

@implementation UPMoveAPI

+ (void)getMovesWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion
{
	if (limit == 0) limit = 10;
	NSDictionary *params = @{ @"limit" : @(limit) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me/moves" params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPMove *move = [[UPMove alloc] init];
				[move decodeFromDictionary:jsonItem];
				
				[results addObject:move];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)getMovesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion
{
	NSDictionary *params = @{ @"start_time" : @([startDate timeIntervalSince1970]), @"end_time" : @([endDate timeIntervalSince1970]) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me/moves" params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPMove *move = [[UPMove alloc] init];
				[move decodeFromDictionary:jsonItem];
				
				[results addObject:move];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)refreshMove:(UPMove *)move completion:(UPMoveAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:move completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)getMoveGraphImage:(UPMove *)move completion:(UPBaseEventAPIImageCompletion)completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:move.graphImageURL]];
		
#if TARGET_OS_MAC && !TARGET_IPHONE_SIMULATOR
		NSImage *image = [[NSImage alloc] initWithData:imageData];
#else
		UIImage *image = [UIImage imageWithData:imageData];
#endif
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completion != nil) completion(image);
		});
	});
}

+ (void)getMoveSnapshot:(UPMove *)move completion:(UPBaseEventAPISnapshotCompletion)completion
{
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/moves/%@/snapshot", move.xid] params:nil];
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

@implementation UPMove

- (NSString *)apiType
{
	return kMoveType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	NSDictionary *details = dictionary[@"details"];
	self.activeTime = [details numberForKey:@"active_time"];
	self.inactiveTime = [details numberForKey:@"inactive_time"];
	self.restingCalories = [details numberForKey:@"bmr"];
	self.activeCalories = [details numberForKey:@"calories"];
	self.totalCalories = @( [self.restingCalories floatValue] + [self.activeCalories floatValue] );
	self.distance = [details numberForKey:@"km"];
	self.steps = [details numberForKey:@"steps"];
	self.longestIdle = [details numberForKey:@"longest_idle"];
	self.longestActive = [details numberForKey:@"longest_active"];
	if ([dictionary stringForKey:@"snapshot_image"].length > 0) self.graphImageURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"snapshot_image"]];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPMove: { xid: %@, title: %@, date: %@, activeTime: %@, inactiveTime: %@, restingCalories: %@, activeCalories: %@, totalCalories: %@, distance: %@, steps: %@, longestIdle: %@, longestActive: %@, imageURL: %@ }", self.xid, self.title, self.date, self.activeTime, self.inactiveTime, self.restingCalories, self.activeCalories, self.totalCalories, self.distance, self.steps, self.longestIdle, self.longestActive, self.graphImageURL];
}

@end
