//
//  UPCardiacEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"
#import "UPGenericEventAPI.h"

@class UPCardiacEvent, UPURLResponse;

typedef void(^UPCardiacEventAPICompletion)(UPCardiacEvent *event, UPURLResponse *response, NSError *error);

@interface UPCardiacEventAPI : NSObject

+ (void)getCardiacEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)postCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion;
+ (void)refreshCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion;
+ (void)deleteCardiacEvent:(UPCardiacEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

@interface UPCardiacEvent : UPGenericEvent

+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note image:(UPImage *)image;
+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note imageURL:(NSString *)imageURL;

@property (nonatomic, strong) NSNumber *heartRate;
@property (nonatomic, strong) NSNumber *systolicPressure;
@property (nonatomic, strong) NSNumber *diastolicPressure;

@end
