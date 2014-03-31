//
//  UPUserAPI.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPUser, UPURLResponse;

typedef void(^UPUserAPICompletion)(UPUser *user, UPURLResponse *response, NSError *error);
typedef void(^UPUserTrendsAPICompletion)(NSArray *trends, UPURLResponse *response, NSError *error);

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
 *  The user's total awake time.
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
