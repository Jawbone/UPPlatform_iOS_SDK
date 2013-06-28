//
//  UPMoodAPI.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPMoodAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"

#import "NSDate+UPPlatform.h"
#import "NSDictionary+UPPlatform.h"

static NSString *kMoodType = @"mood";

@implementation UPMoodAPI

+ (void)getCurrentMoodWithCompletion:(UPMoodAPICompletion)completion
{
    UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me/mood" params:nil];
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        
		UPMood *mood = nil;
		if (error == nil)
		{
			mood = [[UPMood alloc] init];
			[mood decodeFromDictionary:response.data];
		}
        
        if (completion != nil) completion(mood, response, error);
    }];
}

+ (void)postMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion
{
    [UPBaseEventAPI postEvent:mood completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)deleteMood:(UPMood *)mood completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:mood completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

+ (void)refreshMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:mood completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

@end

@implementation UPMood

+ (UPMood *)moodWithType:(UPMoodType)type title:(NSString *)title
{
    UPMood *mood = [[UPMood alloc] init];
    
    mood.type = type;
    mood.title = title;
    
    return mood;
}

- (NSString *)apiType
{
	return kMoodType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	self.type = [[dictionary numberForKey:@"sub_type"] intValue];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.type != 0) [dict setObject:@(self.type) forKey:@"sub_type"];
	
	return dict;
}

/*(
 typedef NS_ENUM(NSUInteger, UPMoodType)
 {
 UPMoodTypeAmazing          = 1,
 UPMoodTypePumpedUp      = 2,
 UPMoodTypeEnergized     = 3,
 UPMoodTypeMeh           = 4,
 UPMoodTypeDragging      = 5,
 UPMoodTypeExhausted     = 6,
 UPMoodTypeDone          = 7,
 UPMoodTypeGood          = 8
 };
 */

- (UPMoodType)typeFromNumber:(NSNumber *)number
{
    switch ([number intValue])
    {
        case 1:
            return UPMoodTypeAmazing;
            break;
            
        case 2:
            return UPMoodTypePumpedUp;
            break;
            
        case 3:
            return UPMoodTypeEnergized;
            break;
            
        case 4:
            return UPMoodTypeMeh;
            break;
            
        case 5:
            return UPMoodTypeDragging;
            break;
            
        case 6:
            return UPMoodTypeExhausted;
            break;
            
        case 7:
            return UPMoodTypeTotallyDone;
            break;
            
        case 8:
            return UPMoodTypeGood;
            break;
            
        default:
            break;
    }
    
    return UPMoodTypeAmazing;
}

- (NSNumber *)numberFromType:(UPMoodType)type
{
    switch (type)
    {
        case UPMoodTypeAmazing:
            return @(1);
            break;
            
        case UPMoodTypePumpedUp:
            return @(2);
            break;
            
        case UPMoodTypeEnergized:
            return @(3);
            break;
            
        case UPMoodTypeMeh:
            return @(4);
            break;
            
        case UPMoodTypeDragging:
            return @(5);
            break;
            
        case UPMoodTypeExhausted:
            return @(6);
            break;
            
        case UPMoodTypeTotallyDone:
            return @(7);
            break;
            
        case UPMoodTypeGood:
            return @(8);
            break;
            
        default:
            break;
    }
    
    return @(1);
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPMood: { xid: %@, title: %@, type: %d, date: %@ }", self.xid, self.title, (int)self.type, self.date];
}

@end
