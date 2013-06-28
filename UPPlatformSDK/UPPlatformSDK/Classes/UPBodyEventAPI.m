//
//  UPBodyEventAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPBodyEventAPI.h"

#import "NSDictionary+UPPlatform.h"

static NSString *kBodyEventType = @"body_events";

@implementation UPBodyEventAPI

+ (void)getBodyEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion
{
	[UPBaseEventAPI getEventsOfType:kBodyEventType destinationClass:[UPBodyEvent class] completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)postBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion
{
	[UPBaseEventAPI postEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)refreshBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)deleteBodyEvent:(UPBodyEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

@end

@implementation UPBodyEvent

+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note image:(UPImage *)image
{
    UPBodyEvent *event = [[UPBodyEvent alloc] init];
    
    event.title = title;
    event.weight = weight;
    event.bodyFat = bodyFat;
    event.leanMass = leanMass;
    event.bmi = bmi;
	event.note = note;
	event.image = image;
    
    return event;
}

+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note imageURL:(NSString *)imageURL
{
    UPBodyEvent *event = [[UPBodyEvent alloc] init];
    
    event.title = title;
    event.weight = weight;
    event.bodyFat = bodyFat;
    event.leanMass = leanMass;
    event.bmi = bmi;
	event.note = note;
	event.imageURL = imageURL;
    
    return event;
}

- (NSString *)apiType
{
	return kBodyEventType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	self.weight = [dictionary numberForKey:@"weight"];
	self.bodyFat = [dictionary numberForKey:@"body_fat"];
	self.leanMass = [dictionary numberForKey:@"lean_mass"];
	self.bmi = [dictionary numberForKey:@"bmi"];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.weight != nil) [dict setObject:self.weight forKey:@"weight"];
	if (self.bodyFat != nil) [dict setObject:self.bodyFat forKey:@"body_fat"];
	if (self.leanMass != nil) [dict setObject:self.leanMass forKey:@"lean_mass"];
	if (self.bmi != nil) [dict setObject:self.bmi forKey:@"bmi"];
	
	return dict;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPBodyEvent: { xid: %@, title: %@, weight: %@, bodyFat: %@, leanMass: %@, bmi: %@, note: %@, imageURL: %@, timeCreated: %@, timeUpdated: %@, date: %@, timeZone: %@ }", self.xid, self.title, self.weight, self.bodyFat, self.leanMass, self.bmi, self.note, self.imageURL, self.timeCreated, self.timeUpdated, self.date, self.timeZone];
}

@end
