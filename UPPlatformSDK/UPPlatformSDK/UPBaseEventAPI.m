//
//  UPBaseEventAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPBaseEventAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"
#import "NSDate+UPPlatform.h"
#import "NSDictionary+UPPlatform.h"
#import "UPMealAPI.h"

@implementation UPBaseEventAPI

+ (void)getEventsOfType:(NSString *)type destinationClass:(Class)destClass completion:(UPBaseEventAPICompletion)completion
{
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/users/@me/%@", type] params:nil];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        NSMutableArray *results = [NSMutableArray array];
        NSArray *jsonItems = response.data[@"items"];
        for (NSDictionary *jsonItem in jsonItems)
        {
			UPBaseEvent *event = [[destClass alloc] init];
			[event decodeFromDictionary:jsonItem];
			
            [results addObject:event];
        }
        
        if (completion != nil) completion(results, response, error);
    }];
}

+ (void)updateEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion
{
    NSDictionary *params = [event encodeToDictionary];
	UIImage *image = [event respondsToSelector:@selector(image)] ? [event performSelector:@selector(image)] : nil;
	if (image == nil && [event respondsToSelector:@selector(photo)]) image = [event performSelector:@selector(photo)];
	
	UPURLRequest *request = [UPURLRequest postRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/%@/partialUpdate", event.apiType, event.xid] params:params image:image];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		if (error == nil)
		{
			[event decodeFromDictionary:response.data];
		}
		
        if (completion != nil) completion(event, response, error);
    }];
}

+ (void)postEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	NSDictionary *params = [event encodeToDictionary];
	UIImage *image = [event respondsToSelector:@selector(image)] ? [event performSelector:@selector(image)] : nil;
	if (image == nil && [event respondsToSelector:@selector(photo)]) image = [event performSelector:@selector(photo)];
	
	UPURLRequest *request = [UPURLRequest postRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/users/@me/%@", event.apiType] params:params image:image];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		if (error == nil)
		{
			[event decodeFromDictionary:response.data];
		}
		
        if (completion != nil) completion(event, response, error);
    }];
}

+ (void)refreshEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/%@", event.apiType, event.xid] params:nil];
	[[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		if (error == nil)
		{
			[event decodeFromDictionary:response.data];
		}
		
		if (completion != nil) completion(event, response, error);
	}];
}

+ (void)deleteEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	UPURLRequest *request = [UPURLRequest deleteRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/%@", event.apiType, event.xid] params:nil];
	[[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(nil, response, error);
	}];
}

@end

@implementation UPBaseEvent

- (NSString *)apiType
{
	NSAssert(NO, @"UPBaseEvent must be subclassed.");
	return nil;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		self.date = [NSDate date];
		self.timeCreated = [NSDate date];
		self.timeUpdated = [NSDate date];
		self.timeZone = [NSTimeZone localTimeZone];
	}
	
	return self;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.xid = [dictionary stringForKey:@"xid"];
	self.title = [dictionary stringForKey:@"title"];
	self.timeCreated = [NSDate dateWithTimeIntervalSince1970:[[dictionary numberForKey:@"time_created"] doubleValue]];
	self.timeUpdated = [NSDate dateWithTimeIntervalSince1970:[[dictionary numberForKey:@"time_updated"] doubleValue]];
	self.timeZone = [NSTimeZone timeZoneWithName:[dictionary[@"details"] stringForKey:@"tz"]];
	self.date = [NSDate dateFromDayInt:[[dictionary numberForKey:@"date"] intValue] inTimeZone:self.timeZone];
}

- (NSDictionary *)encodeToDictionary
{
    NSAssert(self.title != nil, @"UPBaseEvent instances must include a title.");
    
	NSDictionary *dict = @{
						@"title" : self.title,
						@"time_created" : @([self.timeCreated timeIntervalSince1970]),
						@"tz" : self.timeZone.name
	  };
	
	return dict;
}

@end

@implementation UPSnapshot

+ (UPSnapshot *)snapshotWithArray:(NSArray *)array
{
	NSMutableArray *results = [NSMutableArray array];
	for (NSArray *snapshotArray in array)
	{
		if (snapshotArray.count == 2)
		{
			NSNumber *timeNumber = snapshotArray[0];
			NSNumber *valueNumber = snapshotArray[1];
			
			UPSnapshotTick *snapshot = [[UPSnapshotTick alloc] init];
			snapshot.timestamp = [NSDate dateWithTimeIntervalSince1970:[timeNumber doubleValue]];
			snapshot.value = valueNumber;
			[results addObject:snapshot];
		}
	}
	
	UPSnapshot *snapshot = [[UPSnapshot alloc] init];
	snapshot.ticks = results;
	
	return snapshot;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPSnapshot: { ticks: %@ }", self.ticks];
}

@end

@implementation UPSnapshotTick

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPSnapshotTick: { timestamp: %@, value: %@ }", self.timestamp, self.value];
}

@end
