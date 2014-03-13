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

typedef NS_ENUM(NSUInteger, UPUserTrendsRangeType)
{
	UPUserTrendsRangeTypeDays,
	UPUserTrendsRangeTypeWeeks
};

typedef NS_ENUM(NSUInteger, UPUserTrendsBucketSize)
{
	UPUserTrendsBucketSizeDays,
	UPUserTrendsBucketSizeWeeks,
	UPUserTrendsBucketSizeMonths,
	UPUserTrendsBucketSizeYears
};

typedef NS_ENUM(NSUInteger, UPUserGender)
{
	UPUserGenderMale,
	UPUserGenderFemale
};

@interface UPUserAPI : NSObject

+ (void)getCurrentUserWithCompletion:(UPUserAPICompletion)completion;
+ (void)getFriendsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)getTrendsWithEndDate:(NSDate *)endDate rangeType:(UPUserTrendsRangeType)rangeType rangeDuration:(NSUInteger)rangeDuration bucketSize:(UPUserTrendsBucketSize)bucketSize completion:(UPUserTrendsAPICompletion)completion;

@end

@interface UPUser : NSObject <UPBaseObject>

@property (nonatomic, strong) NSString *xid;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *imageURL;

@end

@interface UPTrend : NSObject <UPBaseObject>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, assign) UPUserGender gender;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *moveDistance;
@property (nonatomic, strong) NSNumber *moveSteps;
@property (nonatomic, strong) NSNumber *moveWorkoutTime;
@property (nonatomic, strong) NSNumber *moveActiveTime;
@property (nonatomic, strong) NSNumber *moveCalories;
@property (nonatomic, strong) NSNumber *sleepLight;
@property (nonatomic, strong) NSNumber *sleepDeep;
@property (nonatomic, strong) NSNumber *sleepAwake;
@property (nonatomic, strong) NSNumber *sleepTimeAsleep;
@property (nonatomic, strong) NSNumber *sleepTimeAwake;
@property (nonatomic, strong) NSNumber *eatProtein;
@property (nonatomic, strong) NSNumber *eatCalcium;
@property (nonatomic, strong) NSNumber *eatSaturatedFat;
@property (nonatomic, strong) NSNumber *eatCalories;
@property (nonatomic, strong) NSNumber *eatSodium;
@property (nonatomic, strong) NSNumber *eatSugar;
@property (nonatomic, strong) NSNumber *eatCarbs;
@property (nonatomic, strong) NSNumber *eatFiber;

@end
