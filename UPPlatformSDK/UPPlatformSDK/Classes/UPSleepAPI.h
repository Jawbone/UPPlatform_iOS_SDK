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

@interface UPSleepAPI : NSObject

+ (void)getSleepsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)getSleepsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

+ (void)postSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion;
+ (void)refreshSleep:(UPSleep *)sleep completion:(UPSleepAPICompletion)completion;
+ (void)deleteSleep:(UPSleep *)sleep completion:(UPBaseEventAPICompletion)completion;
+ (void)getSleepGraphImage:(UPSleep *)sleep completion:(UPBaseEventAPIImageCompletion)completion;
+ (void)getSleepSnapshot:(UPSleep *)sleep completion:(UPBaseEventAPISnapshotCompletion)completion;

@end

@interface UPSleep : UPBaseEvent

+ (UPSleep *)sleepWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@property (nonatomic, strong) NSDate *timeCompleted;
@property (nonatomic, strong) NSDate *asleepTime;
@property (nonatomic, strong) NSDate *awakeTime;
@property (nonatomic, strong) NSNumber *totalTimeAwake;
@property (nonatomic, strong) NSNumber *totalTimeLight;
@property (nonatomic, strong) NSNumber *totalTimeDeep;
@property (nonatomic, strong) NSNumber *totalTime;
@property (nonatomic, strong) NSNumber *quality;
@property (nonatomic, strong) NSNumber *awakenings;
@property (nonatomic, strong) NSDate *smartAlarmFireTime;
@property (nonatomic, strong) NSString *graphImageURL;

@end
