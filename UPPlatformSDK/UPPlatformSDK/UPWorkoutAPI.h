//
//  UPWorkoutAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"
#import "UPMoveAPI.h"

@class UPWorkout, UPURLResponse;

typedef void(^UPWorkoutAPICompletion)(UPWorkout *workout, UPURLResponse *response, NSError *error);

/**
 *  Provides an interface for interacting with the user's workouts.
 */
@interface UPWorkoutAPI : NSObject

/**
 * Request recent workout events for the currently authenticated user.
 *
 * @param limit The maximum number of workout events to be returned.
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)getWorkoutsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request workout events between two points in time for the currently authenticated user.
 *
 * @param startDate Request workout events after this date. The date must be in the past.
 * @param endDate Request workout events before this date. The date must be in the past.
 * @param completion Block to be executed upon completion. The block is passed the results.
 */
+ (void)getWorkoutsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Post a new workout event to the feed of the currently authenticated user.
 *
 * @param workout A new workout event to be added to the feed.
 * @param completion Block to be executed upon request completion.
 */
+ (void)postWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion;

/**
 * Request an existing workout event. The event must be visible to the currently authenticated user.
 *
 * @param workout An existing workout event.
 * @param completion Block to be executed upon completion. The block is passed the result.
 */
+ (void)refreshWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion;

/**
 * Delete an existing workout event. The event must belong to the currently authenticated user.
 *
 * @param workout The existing workout event to be deleted.
 * @param completion Block to be executed upon completion.
 */
+ (void)deleteWorkout:(UPWorkout *)workout completion:(UPBaseEventAPICompletion)completion;

/**
 * Request the graph image for the workout event.
 *
 * @param workout The workout for which to request the graph.
 * @param completion Block to be executed upon completion. The block is passed the result image.
 */
+ (void)getWorkoutGraphImage:(UPWorkout *)workout completion:(UPBaseEventAPIImageCompletion)completion;

/**
 * Requests individual ticks in the workout. Ticks have finer grain detail about the move.
 *
 * @param workout The workout for which to request the ticks.
 * @param completion Block to be executed upon completion. The block is passed the array of ticks.
 */
+ (void)getWorkoutTicks:(UPWorkout *)workout completion:(UPBaseEventAPIArrayCompletion)completion;

@end

/**
 * The available types of workouts.
 */
typedef NS_ENUM(NSUInteger, UPWorkoutType)
{
	UPWorkoutTypeWalk					= 1,
	UPWorkoutTypeRun					= 2,
	UPWorkoutTypeWeightLifting			= 3,
	UPWorkoutTypeCrossTrain				= 4,
	UPWorkoutTypeNikeTraining			= 5,
	UPWorkoutTypeYoga					= 6,
	UPWorkoutTypePilates				= 7,
	UPWorkoutTypeBodyWeightExercise		= 8,
	UPWorkoutTypeCrossfit				= 9,
	UPWorkoutTypeP90X					= 10,
	UPWorkoutTypeZumba					= 11,
	UPWorkoutTypeTRX					= 12,
	UPWorkoutTypeSwim					= 13,
	UPWorkoutTypeBike					= 14,
	UPWorkoutTypeElliptical				= 15,
	UPWorkoutTypeBarMethod				= 16,
	UPWorkoutTypeKinectExercise			= 17,
	UPWorkoutTypeTennis					= 18,
	UPWorkoutTypeBasketball				= 19,
	UPWorkoutTypeGolf					= 20,
	UPWorkoutTypeSoccer					= 21,
	UPWorkoutTypeSkiOrSnowboard			= 22,
	UPWorkoutTypeDance					= 23,
	UPWorkoutTypeHike					= 24,
	UPWorkoutTypeCrossCountrySki		= 25,
	UPWorkoutTypeStationaryBike			= 26,
	UPWorkoutTypeCardio					= 27,
	UPWorkoutTypeGame					= 28
};

/**
 * The available types of workout intensities.
 */
typedef NS_ENUM(NSUInteger, UPWorkoutIntensity)
{
	UPWorkoutIntensityEasy				= 1,
	UPWorkoutIntensityModerate			= 2,
	UPWorkoutIntensityIntermediate		= 3,
	UPWorkoutIntensityDifficult			= 4,
	UPWorkoutIntensityHard				= 5
};

/**
 *  A workout represents a duration within the days move where the user worked out.
 */
@interface UPWorkout : UPMove

/**
 * Create a new workout event.
 *
 * @param type The type of workout that is being created.
 * @param startTime The time when the workout was started. The time must be in the past.
 * @param endTime The time the workout had finished. The time must be in the past.
 * @param intensity The intensity of the workout.
 * @param caloriesBurned The number of calories burned during the workout.
 * @return Returns a new workout event.
 */
+ (UPWorkout *)workoutWithType:(UPWorkoutType)type startTime:(NSDate *)startTime endTime:(NSDate *)endTime intensity:(UPWorkoutIntensity)intensity caloriesBurned:(NSNumber *)caloriesBurned;

/**
 *  The workout type.
 */
@property (nonatomic, assign) UPWorkoutType type;

/**
 *  The workout intensity.
 */
@property (nonatomic, assign) UPWorkoutIntensity intensity;

/**
 *  The time the workout was completed.
 */
@property (nonatomic, strong) NSDate *timeCompleted;

/**
 *  The URL for the workout's image.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 *  The URL for the workout's route image.
 */
@property (nonatomic, strong) NSString *routeImageURL;

/**
 *  The workout's image.
 */
@property (nonatomic, strong) UPImage *image;

@end
