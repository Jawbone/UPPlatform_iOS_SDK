//
//  UPBandEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 3/31/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

/**
 *  Provides an interface for getting UP24 band events.
 */
@interface UPBandEventAPI : NSObject

/**
 * Request band events between two points in time for the currently authenticated user.
 *
 * @param startDate The earliest date to fetch band events from.
 * @param endDate The date up to which to fetch band events to.
 * @param completion Block to be executed upon completion. The block is passed the results or any error information.
 */
+ (void)getBandEventsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

@end

/**
 *  Available action types for hardware band events.
 */
typedef NS_ENUM(NSUInteger, UPBandEventActionType)
{
    UPBandEventActionTypeEnterSleepMode,
    UPBandEventActionTypeExitSleepMode,
    UPBandEventActionTypeEnterStopwatchMode,
    UPBandEventActionTypeExitStopwatchMode
};

/**
 *  An UP24 hardware band event, which includes entering and exiting both sleep mode and stopwatch (workout) mode.
 */
@interface UPBandEvent : UPBaseEvent

/**
 *  The action type of the band event.
 */
@property (nonatomic, assign) UPBandEventActionType actionType;

@end
