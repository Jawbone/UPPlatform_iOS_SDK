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

@interface UPWorkoutAPI : NSObject

+ (void)getWorkoutsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)getWorkoutsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

+ (void)postWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion;
+ (void)refreshWorkout:(UPWorkout *)workout completion:(UPWorkoutAPICompletion)completion;
+ (void)deleteWorkout:(UPWorkout *)workout completion:(UPBaseEventAPICompletion)completion;
+ (void)getWorkoutGraphImage:(UPWorkout *)workout completion:(UPBaseEventAPIImageCompletion)completion;
+ (void)getWorkoutSnapshot:(UPWorkout *)workout completion:(UPBaseEventAPISnapshotCompletion)completion;

@end

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

typedef NS_ENUM(NSUInteger, UPWorkoutIntensity)
{
	UPWorkoutIntensityEasy				= 1,
	UPWorkoutIntensityModerate			= 2,
	UPWorkoutIntensityIntermediate		= 3,
	UPWorkoutIntensityDifficult			= 4,
	UPWorkoutIntensityHard				= 5
};

@interface UPWorkout : UPMove

+ (UPWorkout *)workoutWithType:(UPWorkoutType)type startTime:(NSDate *)startTime endTime:(NSDate *)endTime intensity:(UPWorkoutIntensity)intensity caloriesBurned:(NSNumber *)caloriesBurned;

@property (nonatomic, assign) UPWorkoutType type;
@property (nonatomic, assign) UPWorkoutIntensity intensity;
@property (nonatomic, strong) NSDate *timeCompleted;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *routeImageURL;
@property (nonatomic, strong) UPImage *image;

@end
