//
//  UPMoveAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPMove, UPURLResponse;

typedef void(^UPMoveAPICompletion)(UPMove *move, UPURLResponse *response, NSError *error);

/**
 *  Provides an interface for interacting with the user's move events.
 */
@interface UPMoveAPI : NSObject

/**
 * Request recent move events for the currently authenticated user.
 *
 * @param limit The maximum number of events to return.
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)getMovesWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request move events between two points in time for the currently authenticated user.
 *
 * @param startDate The earliest date to fetch move events from.
 * @param endDate The date up to which to fetch move events to.
 * @param completion Block to be executed upon completion. The block is passed the results or any error information.
 */
+ (void)getMovesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request a single move event from the user's history.
 *
 * @param move The move event to request. The event must be visible to the user.
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)refreshMove:(UPMove *)move completion:(UPMoveAPICompletion)completion;

/**
 * Request a graph image for a sleep event.
 *
 * @param move The move event to request the graph image for. The event must be visible to the user.
 * @param completion Block to be executed upon completion. The block is passed the graph image.
 */
+ (void)getMoveGraphImage:(UPMove *)move completion:(UPBaseEventAPIImageCompletion)completion;

/**
 * Requests individual ticks in the move. Ticks have finer grain detail about the move.
 *
 * @param move The move event to request the ticks for.
 * @param completion Block to be executed upon completion. The block is passed the ticks array or any error information.
 */
+ (void)getMoveTicks:(UPMove *)move completion:(UPBaseEventAPIArrayCompletion)completion;

@end

/**
 *  A move represents the user's activity throughout a day.
 */
@interface UPMove : UPBaseEvent

/**
 *  The duration of time for which the user was active.
 */
@property (nonatomic, strong) NSNumber *activeTime;

/**
 *  The duration of time for which the user was inactive.
 */
@property (nonatomic, strong) NSNumber *inactiveTime;

/**
 *  The number of resting calories burned.
 */
@property (nonatomic, strong) NSNumber *restingCalories;

/**
 *  The number of active calories burned.
 */
@property (nonatomic, strong) NSNumber *activeCalories;

/**
 *  The number of total calories burned.
 */
@property (nonatomic, strong) NSNumber *totalCalories;

/**
 *  The distance traveled during the move event.
 */
@property (nonatomic, strong) NSNumber *distance;

/**
 *  The number of steps taken during the event.
 */
@property (nonatomic, strong) NSNumber *steps;

/**
 *  The longest time that the user spent idle during the move event.
 */
@property (nonatomic, strong) NSNumber *longestIdle;

/**
 *  The longest period of time that the user spent active during the move event.
 */
@property (nonatomic, strong) NSNumber *longestActive;

/**
 *  The URL for the graph image for the move event.
 */
@property (nonatomic, strong) NSString *graphImageURL;

@end

/**
 *  A move tick represents details about the move at a small section in time.
 */
@interface UPMoveTick : NSObject <UPBaseObject>

/**
 *  The minutes of active time in the tick.
 */
@property (nonatomic, strong) NSNumber *activeTime;

/**
 *  The calories burned during the tick.
 */
@property (nonatomic, strong) NSNumber *calories;

/**
 *  The distance traveled during the tick.
 */
@property (nonatomic, strong) NSNumber *distance;

/**
 *  The average speed during the tick.
 */
@property (nonatomic, strong) NSNumber *speed;

/**
 *  The total number of steps taken during the tick.
 */
@property (nonatomic, strong) NSNumber *steps;

/**
 *  The timestamp of the tick.
 */
@property (nonatomic, strong) NSDate *timestamp;

@end
