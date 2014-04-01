//
//  UPBandEventAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 3/31/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "UPBandEventAPI.h"

#import "UPPlatform.h"
#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "NSDictionary+UPPlatform.h"

static NSString *kBandEventType = @"bandevents";

@implementation UPBandEventAPI

+ (void)getBandEventsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion
{
	NSDictionary *params = @{ @"start_time" : @(floor([startDate timeIntervalSince1970])), @"end_time" : @(floor([endDate timeIntervalSince1970])) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/bandevents", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPBandEvent *event = [[UPBandEvent alloc] init];
				[event decodeFromDictionary:jsonItem];
				
				[results addObject:event];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

@end

@implementation UPBandEvent

- (NSString *)apiType
{
	return kBandEventType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	self.actionType = [self actionTypeFromString:[dictionary stringForKey:@"action"]];
    self.timeZone = [NSTimeZone timeZoneWithName:[dictionary stringForKey:@"tz"]];
}

- (UPBandEventActionType)actionTypeFromString:(NSString *)typeString
{
    UPBandEventActionType type = 0;
    
    if ([typeString isEqualToString:@"enter_sleep_mode"])
    {
        type = UPBandEventActionTypeEnterSleepMode;
    }
    else if ([typeString isEqualToString:@"exit_sleep_mode"])
    {
        type = UPBandEventActionTypeExitSleepMode;
    }
    else if ([typeString isEqualToString:@"enter_stopwatch_mode"])
    {
        type = UPBandEventActionTypeEnterStopwatchMode;
    }
    else if ([typeString isEqualToString:@"exit_stopwatch_mode"])
    {
        type = UPBandEventActionTypeExitStopwatchMode;
    }
    
    return type;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPBandEvent: { date: %@, action: %@, timeCreated: %@, timeZone: %@ }", self.date, @(self.actionType), self.timeCreated, self.timeZone];
}

@end
