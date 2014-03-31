//
//  UPUserAPI.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPUser, UPURLResponse, UPUserGoals, UPUserSharingSettings;

typedef void(^UPUserAPICompletion)(UPUser *user, UPURLResponse *response, NSError *error);
typedef void(^UPUserTrendsAPICompletion)(NSArray *trends, UPURLResponse *response, NSError *error);
typedef void(^UPUserGoalsAPICompletion)(UPUserGoals *goals, UPURLResponse *response, NSError *error);
typedef void(^UPUserSharingSettingsAPICompletion)(UPUserSharingSettings *sharingSettings, UPURLResponse *response, NSError *error);

/**
 *  The type of range to request when getting user trends.
 */
typedef NS_ENUM(NSUInteger, UPUserTrendsRangeType)
{
    UPUserTrendsRangeTypeDays,
    UPUserTrendsRangeTypeWeeks
};

/**
 *  The bucket size to request when getting user trends.
 */
typedef NS_ENUM(NSUInteger, UPUserTrendsBucketSize)
{
	UPUserTrendsBucketSizeDays,
	UPUserTrendsBucketSizeWeeks,
	UPUserTrendsBucketSizeMonths,
	UPUserTrendsBucketSizeYears
};

/**
 *  The gender of the user.
 */
typedef NS_ENUM(NSUInteger, UPUserGender)
{
	UPUserGenderMale,
	UPUserGenderFemale
};

/**
 *  Provides an interface for interacting with the logged in user.
 */
@interface UPUserAPI : NSObject

/**
 *  Gets details about the current user.
 */
+ (void)getCurrentUserWithCompletion:(UPUserAPICompletion)completion;

/**
 *  Gets a list of the current user's friend xids.
 *  These can be used to map the user's friends with other users registered with the 3rd party application.
 */
+ (void)getFriendsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;

/**
 *  Gets a set of trends about the user.
 */
+ (void)getTrendsWithEndDate:(NSDate *)endDate rangeType:(UPUserTrendsRangeType)rangeType rangeDuration:(NSUInteger)rangeDuration bucketSize:(UPUserTrendsBucketSize)bucketSize completion:(UPUserTrendsAPICompletion)completion;

/**
 *  Gets the user's most recent goals.
 */
+ (void)getUserGoalsWithCompletion:(UPUserGoalsAPICompletion)completion;

/**
 *  Gets the user's sharing settings.
 */
+ (void)getUserSharingSettingsWithCompletion:(UPUserSharingSettingsAPICompletion)completion;

@end

/**
 *  Represents a logged in user.
 */
@interface UPUser : NSObject <UPBaseObject>

/**
 *  The user's unique identifier.
 */
@property (nonatomic, strong) NSString *xid;

/**
 *  The user's first name.
 */
@property (nonatomic, strong) NSString *firstName;

/**
 *  The user's last name.
 */
@property (nonatomic, strong) NSString *lastName;

/**
 *  The user's image URL.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 *  The user's most recent weight, in kilograms.
 */
@property (nonatomic, strong) NSNumber *weight;

/**
 *  The user's height, in meters.
 */
@property (nonatomic, strong) NSNumber *height;

/**
 *  The user's gender.
 */
@property (nonatomic, assign) UPUserGender gender;

@end

/**
 *  The user's current goals.
 */
@interface UPUserGoals : NSObject <UPBaseObject>

/**
 *  The user's daily step goal.
 */
@property (nonatomic, strong) NSNumber *moveSteps;

/**
 *  The user's daily sleep goal.
 */
@property (nonatomic, strong) NSNumber *sleepTotal;

/**
 *  The user's current weight goal.
 */
@property (nonatomic, strong) NSNumber *bodyWeight;

/**
 *  The user's saturated fat goal.
 */
@property (nonatomic, strong) NSNumber *eatSaturatedFat;

/**
 *  The user's sodium goal.
 */
@property (nonatomic, strong) NSNumber *eatSodium;

/**
 *  The user's carbohydrate goal.
 */
@property (nonatomic, strong) NSNumber *eatCarbs;

/**
 *  The user's cholesterol goal.
 */
@property (nonatomic, strong) NSNumber *eatCholesterol;

/**
 *  The user's fiber goal.
 */
@property (nonatomic, strong) NSNumber *eatFiber;

/**
 *  The user's protein goal.
 */
@property (nonatomic, strong) NSNumber *eatProtein;

/**
 *  The user's calcium goal.
 */
@property (nonatomic, strong) NSNumber *eatCalcium;

/**
 *  The user's sugar goal.
 */
@property (nonatomic, strong) NSNumber *eatSugar;

/**
 *  The user's unsaturated fat goal.
 */
@property (nonatomic, strong) NSNumber *eatUnsaturatedFat;

@end

/**
 *  A trend represents the user's data at a specific point in time, with a given bucket size.
 *  Trends are useful to measure data over time, such as in a graph.
 */
@interface UPTrend : NSObject <UPBaseObject>

/**
 *  The date of the trend.
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  The user's weight.
 */
@property (nonatomic, strong) NSNumber *weight;

/**
 *  The user's height.
 */
@property (nonatomic, strong) NSNumber *height;

/**
 *  The user's gender.
 */
@property (nonatomic, assign) UPUserGender gender;

/**
 *  The user's age.
 */
@property (nonatomic, strong) NSNumber *age;

/**
 *  The user's total distance moved.
 */
@property (nonatomic, strong) NSNumber *moveDistance;

/**
 *  The user's total steps taken.
 */
@property (nonatomic, strong) NSNumber *moveSteps;

/**
 *  The user's total workout time.
 */
@property (nonatomic, strong) NSNumber *moveWorkoutTime;

/**
 *  The user's total active time.
 */
@property (nonatomic, strong) NSNumber *moveActiveTime;

/**
 *  The user's total calories moved.
 */
@property (nonatomic, strong) NSNumber *moveCalories;

/**
 *  The user's total light sleep.
 */
@property (nonatomic, strong) NSNumber *sleepLight;

/**
 *  The user's total sound sleep.
 */
@property (nonatomic, strong) NSNumber *sleepSound;

/**
 *  The user's total awake time.
 */
@property (nonatomic, strong) NSNumber *sleepAwake;

/**
 *  The user's total time asleep.
 */
@property (nonatomic, strong) NSNumber *sleepTimeAsleep;

/**
 *  The last time the user woke up, in seconds from/to midnight.
 */
@property (nonatomic, strong) NSNumber *sleepTimeAwake;

/**
 *  The user's protein eaten.
 */
@property (nonatomic, strong) NSNumber *eatProtein;

/**
 *  The user's calcium eaten.
 */
@property (nonatomic, strong) NSNumber *eatCalcium;

/**
 *  The user's saturated fat eaten.
 */
@property (nonatomic, strong) NSNumber *eatSaturatedFat;

/**
 *  The user's calories eaten.
 */
@property (nonatomic, strong) NSNumber *eatCalories;

/**
 *  The user's sodium eaten.
 */
@property (nonatomic, strong) NSNumber *eatSodium;

/**
 *  The user's sugar eaten.
 */
@property (nonatomic, strong) NSNumber *eatSugar;

/**
 *  The user's carbs eaten.
 */
@property (nonatomic, strong) NSNumber *eatCarbs;

/**
 *  The user's fiber eaten.
 */
@property (nonatomic, strong) NSNumber *eatFiber;

@end

/**
 *  The user's sharing settings.
 */
@interface UPUserSharingSettings : NSObject <UPBaseObject>

/**
 *  Whether the user has chosen to share body events.
 */
@property (nonatomic, assign) BOOL shareBody;

/**
 *  Whether the user has chosen to meals.
 */
@property (nonatomic, assign) BOOL shareEat;

/**
 *  Whether the user has chosen to share mood events.
 */
@property (nonatomic, assign) BOOL shareMood;

/**
 *  Whether the user has chosen to share move events.
 */
@property (nonatomic, assign) BOOL shareMove;

/**
 *  Whether the user has chosen to share sleep events.
 */
@property (nonatomic, assign) BOOL shareSleep;

@end
