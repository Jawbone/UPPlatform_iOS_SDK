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

+ (void)getMovesWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)getMovesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

+ (void)refreshMove:(UPMove *)move completion:(UPMoveAPICompletion)completion;
+ (void)getMoveGraphImage:(UPMove *)move completion:(UPBaseEventAPIImageCompletion)completion;
+ (void)getMoveSnapshot:(UPMove *)move completion:(UPBaseEventAPISnapshotCompletion)completion;

@end

@interface UPMove : UPBaseEvent

@property (nonatomic, strong) NSNumber *activeTime;
@property (nonatomic, strong) NSNumber *inactiveTime;
@property (nonatomic, strong) NSNumber *restingCalories;
@property (nonatomic, strong) NSNumber *activeCalories;
@property (nonatomic, strong) NSNumber *totalCalories;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *steps;
@property (nonatomic, strong) NSNumber *longestIdle;
@property (nonatomic, strong) NSNumber *longestActive;
@property (nonatomic, strong) NSString *graphImageURL;

@end
