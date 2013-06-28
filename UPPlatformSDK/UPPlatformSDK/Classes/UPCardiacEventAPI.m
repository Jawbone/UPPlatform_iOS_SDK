//
//  UPCardiacEventAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPCardiacEventAPI.h"

#import "NSDictionary+UPPlatform.h"

static NSString *kCardiacEventType = @"cardiac_events";

@implementation UPCardiacEventAPI

+ (void)getCardiacEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion
{
	[UPBaseEventAPI getEventsOfType:kCardiacEventType destinationClass:[UPCardiacEvent class] completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)postCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion
{
	[UPBaseEventAPI postEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)refreshCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)deleteCardiacEvent:(UPCardiacEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

@end

@implementation UPCardiacEvent

+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note image:(UPImage *)image
{
    UPCardiacEvent *event = [[UPCardiacEvent alloc] init];
    
    event.title = title;
    event.heartRate = heartRate;
    event.systolicPressure = systolicPressure;
    event.diastolicPressure	= diastolicPressure;
	event.note = note;
	event.image = image;
    
    return event;
}

+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note imageURL:(NSString *)imageURL
{
    UPCardiacEvent *event = [[UPCardiacEvent alloc] init];
    
    event.title = title;
    event.heartRate = heartRate;
    event.systolicPressure = systolicPressure;
    event.diastolicPressure	= diastolicPressure;
	event.note = note;
	event.imageURL = imageURL;
    
    return event;
}

- (NSString *)apiType
{
	return kCardiacEventType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	self.heartRate = [dictionary numberForKey:@"heart_rate"];
	self.systolicPressure = [dictionary numberForKey:@"systolic_pressure"];
	self.diastolicPressure = [dictionary numberForKey:@"diastolic_pressure"];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.heartRate != nil) [dict setObject:self.heartRate forKey:@"heart_rate"];
	if (self.systolicPressure != nil) [dict setObject:self.systolicPressure forKey:@"systolic_pressure"];
	if (self.diastolicPressure != nil) [dict setObject:self.diastolicPressure forKey:@"diastolic_pressure"];
	
	return dict;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPCardiacEvent: { xid: %@, title: %@, heartRate: %@, systolicPressure: %@, diastolicPressure: %@, note: %@, imageURL: %@, timeCreated: %@, timeUpdated: %@, date: %@, timeZone: %@ }", self.xid, self.title, self.heartRate, self.systolicPressure, self.diastolicPressure, self.note, self.imageURL, self.timeCreated, self.timeUpdated, self.date, self.timeZone];
}

@end