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

/**
 *  Provides an interface for interacting with cardiac events.
 */
@interface UPCardiacEventAPI : NSObject

/**
 * Request recent cardiac events for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)getCardiacEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Post a cardiac event for the currently authenticated user.
 *
 * @param event A new cardiac event.
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)postCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion;

/**
 * Refresh (update) an existing cardiac event for the currently authenticated user.
 *
 * @param event An existing cardiac event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)refreshCardiacEvent:(UPCardiacEvent *)event completion:(UPCardiacEventAPICompletion)completion;

/**
 * Delete a cardiac event for the currently authenticated user.
 *
 * @param event An existing cardiac event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)deleteCardiacEvent:(UPCardiacEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

/**
 *  A cardiac represents cardiac characteristics of the user, like heart rate.
 */
@interface UPCardiacEvent : UPGenericEvent

/**
 * Create a new cardiac event with supplied parameters for the currently authenticated user.
 *
 * @param title Title for the new event.
 * @param heartRate Heart rate.
 * @param systolicPressure Systolic pressure.
 * @param diastolicPressure Diastolic pressure.
 * @param image Associated image.
 */
+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note image:(UPImage *)image;

/**
 * Create a new cardiac event with supplied parameters for the currently authenticated user.
 *
 * @param title Title for the new event.
 * @param heartRate Heart rate.
 * @param systolicPressure Systolic pressure.
 * @param diastolicPressure Diastolic pressure.
 * @param imageURL The URL for the associated image.
 */
+ (UPCardiacEvent *)eventWithTitle:(NSString *)title heartRate:(NSNumber *)heartRate systolicPressure:(NSNumber *)systolicPressure diastolicPressure:(NSNumber *)diastolicPressure note:(NSString *)note imageURL:(NSString *)imageURL;

/**
 * Heart rate for the currently authenticated user.
 */
@property (nonatomic, strong) NSNumber *heartRate;

/**
 * Systolic pressure for the currently authenticated user.
 */
@property (nonatomic, strong) NSNumber *systolicPressure;

/**
 * Diastolic pressure for the currently authenticated user.
 */
@property (nonatomic, strong) NSNumber *diastolicPressure;

@end
