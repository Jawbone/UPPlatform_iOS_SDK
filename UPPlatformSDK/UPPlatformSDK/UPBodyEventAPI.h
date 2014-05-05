//
//  UPBodyEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"
#import "UPGenericEventAPI.h"

@class UPBodyEvent, UPURLResponse;

typedef void(^UPBodyEventAPICompletion)(UPBodyEvent *event, UPURLResponse *response, NSError *error);

/**
 *  Provides an interface for interacting with body events.
 */
@interface UPBodyEventAPI : NSObject

/**
 * Get body composition metrics record events for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)getBodyEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Create a new user event to record body composition metrics for the currently authenticated user.
 * @param event New body event.
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)postBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion;

/**
 * Get a single body composition metric event for the currently authenticated user.
 * @param event Existing body event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)refreshBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion;

/**
 * Delete a single Weight metric event for the currently authenticated user.
 * @param event Existing body event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)deleteBodyEvent:(UPBodyEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

/**
 *  A body event describes body characteristics, like weight and body fat.
 */
@interface UPBodyEvent : UPGenericEvent

/**
 * Create a new body event with supplied parameters for the currently authenticated user.
 *
 * @param title Title of the new event.
 * @param weight Weight in kilograms.
 * @param bodyFat Body fat percentage.
 * @param leanMass Lean mass percentage.
 * @param bmi Body Mass Index.
 * @param note Notes associated with the event.
 * @param image Image to include in the event.
 */
+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note image:(UPImage *)image;

/**
 * Create a new body event with supplied parameters for the currently authenticated user.
 *
 * @param title Title of the new event.
 * @param weight Weight in kilograms.
 * @param bodyFat Body fat percentage.
 * @param leanMass Lean mass percentage.
 * @param bmi Body Mass Index.
 * @param note Notes associated with the event.
 * @param image URL of the image to include in the event.
 */
+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note imageURL:(NSString *)imageURL;

/**
 * Weight in kilograms.
 */
@property (nonatomic, strong) NSNumber *weight;

/**
 * Body fat percentage.
 */
@property (nonatomic, strong) NSNumber *bodyFat;

/**
 * Lean mass percentage.
 */
@property (nonatomic, strong) NSNumber *leanMass;

/**
 * Body Mass Index.
 */
@property (nonatomic, strong) NSNumber *bmi;

@end
