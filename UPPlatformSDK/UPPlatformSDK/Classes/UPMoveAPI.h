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
 * TODO: What is a snapshot?
 *
 * @param move The move event to request the snapshot for.
 * @param completion Block to be executed upon completion. The block is passed the snapshot of any error information.
 */
+ (void)getMoveSnapshot:(UPMove *)move completion:(UPBaseEventAPISnapshotCompletion)completion;

@end

@interface UPMove : UPBaseEvent

/// The duration of time for which the user was active.
@property (nonatomic, strong) NSNumber *activeTime;

/// The duration of time for which the user was inactive.
@property (nonatomic, strong) NSNumber *inactiveTime;

/// The number of resting calories burned. TODO: What does this mean?
@property (nonatomic, strong) NSNumber *restingCalories;

/// The number of active calories burned. TODO: What does this mean?
@property (nonatomic, strong) NSNumber *activeCalories;

/// The number of total calories burned.
@property (nonatomic, strong) NSNumber *totalCalories;

/// The distance traveled during the move event.
@property (nonatomic, strong) NSNumber *distance;

/// The number of steps taken during the event.
@property (nonatomic, strong) NSNumber *steps;

/// The longest time that the user spent idle during the move event.
@property (nonatomic, strong) NSNumber *longestIdle;

/// The longest period of time that the user spent active during the move event.
@property (nonatomic, strong) NSNumber *longestActive;

/// The URL for the graph image for the move event.
@property (nonatomic, strong) NSString *graphImageURL;

@end
