//
//  UPSleepAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPSleep, UPURLResponse;

typedef void(^UPSleepAPICompletion)(UPSleep *sleep, UPURLResponse *response, NSError *error);

/**
 *  Provides an interface for interacting with the user's sleeps.
 */
@interface UPSleepAPI : NSObject

/**
 * Request recent sleep sleep for the currently authenticated user.
 *
 * @param limit The maximum number of events that will be returned.
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)getSleepsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request sleep events between two points in time for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)getSleepsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Post a new sleep event to the user's timeline.
 *
 * @param sleep A new sleep event.
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)postSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion;

/**
 * Request sleep recent sleep events for the currently authenticated user.
 *
 * @param limit
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)refreshSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion;

/**
 * Delete a sleep event. The event must belong to the currently authenticated user.
 *
 * @param sleep The sleep event to be deleted.
 * @param completion Block to be executed upon completion. The block is passed a completion object.
 */
+ (void)deleteSleep:(UPSleep *)sleep completion:(UPBaseEventAPICompletion)completion;

/**
 * Request an image containing a graph for the sleep event. The event must be visible to the currently authenticated user.
 *
 * @param sleep The sleep event to request.
 * @param completion Block to be executed upon completion. The block is passed the result.
 */
+ (void)getSleepGraphImage:(UPSleep *)sleep completion:(UPBaseEventAPIImageCompletion)completion;

/**
 * Requests ticks of the sleep. The ticks provide finer detail about the sleep.
 *
 * @param sleep The sleep event to request the snapshot for.
 * @param completion Block to be executed upon completion. The block is passed the result.
 */
+ (void)getSleepTicks:(UPSleep *)sleep completion:(UPBaseEventAPIArrayCompletion)completion;

@end

/**
 *  Represents a single sleep session. A user can have multiple sleeps per day.
 */
@interface UPSleep : UPBaseEvent

/**
 * Create a new sleep event.
 *
 * @param startTime The time the user went to sleep.
 * @param endTime The time the user woke up.
 * @return Returns a new sleep event.
 */
+ (UPSleep *)sleepWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;

/**
 *  The time the sleep was completed.
 */
@property (nonatomic, strong) NSDate *timeCompleted;

/**
 *  The time when the user went to sleep.
 */
@property (nonatomic, strong) NSDate *asleepTime;

/**
 *  The time when the user woke up.
 */
@property (nonatomic, strong) NSDate *awakeTime;

/**
 *  The total amount of time the user was awake during the sleep.
 */
@property (nonatomic, strong) NSNumber *totalTimeAwake;

/**
 *  The total time the user spent in light sleep.
 */
@property (nonatomic, strong) NSNumber *totalTimeLight;

/**
 *  The total  time the user spent in sound sleep.
 */
@property (nonatomic, strong) NSNumber *totalTimeSound;

/**
 *  The total time the user was asleep.
 */
@property (nonatomic, strong) NSNumber *totalTime;

/**
 *  The quality of the sleep.
 */
@property (nonatomic, strong) NSNumber *quality;

/**
 *  The number of times the user woke up during the sleep.
 */
@property (nonatomic, strong) NSNumber *awakenings;

/**
 *  The time that the user's smart sleep alarm fired.
 */
@property (nonatomic, strong) NSDate *smartAlarmFireTime;

/**
 *  The URL to the graph of the sleep event.
 */
@property (nonatomic, strong) NSString *graphImageURL;

@end

/**
 *  A sleep tick represents details about the sleep at a small section in time.
 */
@interface UPSleepTick : NSObject <UPBaseObject>

/**
 *  The sleep depth of the tick.
 */
@property (nonatomic, strong) NSNumber *depth;

/**
 *  The timestamp of the tick.
 */
@property (nonatomic, strong) NSDate *timestamp;

@end
