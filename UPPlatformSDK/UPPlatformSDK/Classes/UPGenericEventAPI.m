//
//  UPGenericEventAPI.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPGenericEventAPI.h"

#import "UPPlatform.h"
#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "NSDictionary+UPPlatform.h"
#import "NSDate+UPPlatform.h"

static NSString *kGenericEventType = @"generic_events";

@implementation UPGenericEventAPI

+ (void)postGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion
{
	[UPBaseEventAPI postEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)getGenericEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion
{
	[UPBaseEventAPI getEventsOfType:kGenericEventType destinationClass:[UPGenericEvent class] completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)refreshGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)deleteGenericEvent:(UPGenericEvent *)event completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:event completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

@end

@implementation UPGenericEvent

+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note image:(UPImage *)image
{
    UPGenericEvent *event = [[UPGenericEvent alloc] init];
    
    event.title = title;
    event.verb = verb;
    event.attributes = attributes;
    event.note = note;
    event.image = image;
    
    return event;
}

+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note imageURL:(NSString *)imageURL
{
    UPGenericEvent *event = [[UPGenericEvent alloc] init];
    
    event.title = title;
    event.verb = verb;
    event.attributes = attributes;
    event.note = note;
    event.imageURL = imageURL;
    
    return event;
}

- (NSString *)apiType
{
	return kGenericEventType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	self.verb = [dictionary stringForKey:@"verb"];
	self.attributes = dictionary[@"attributes"];
	self.note = [dictionary stringForKey:@"note"];
	if ([dictionary stringForKey:@"image"] != nil) self.imageURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"image"]];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];

	if (self.verb != nil) [dict setObject:self.verb forKey:@"verb"];
	if (self.attributes != nil) [dict setObject:[self dictionaryToString:self.attributes] forKey:@"attributes"];
	if (self.note != nil) [dict setObject:self.note forKey:@"note"];
	if (self.imageURL != nil) [dict setObject:self.imageURL forKey:@"image_url"];
	
	return dict;
}

- (NSString *)dictionaryToString:(NSDictionary *)dictionary
{
    return dictionary == nil ? @"{}" : [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPGenericEvent: { xid: %@, title: %@, verb: %@, attributes: %@, note: %@, imageURL: %@, timeCreated: %@, timeUpdated: %@, date: %@, timeZone: %@ }", self.xid, self.title, self.verb, self.attributes, self.note, self.imageURL, self.timeCreated, self.timeUpdated, self.date, self.timeZone];
}

@end
