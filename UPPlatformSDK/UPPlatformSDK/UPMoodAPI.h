//
//  UPMoodAPI.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/9/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPMood, UPURLResponse;

typedef void(^UPMoodAPICompletion)(UPMood *mood, UPURLResponse *response, NSError *error);

/**
 *  Provides an interface for interacting with the user's moods.
 */
@interface UPMoodAPI : NSObject

/**
 * Request the current mood of the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)getCurrentMoodWithCompletion:(UPMoodAPICompletion)completion;

/**
 * Post a mood update to the currently authenticated user's feed.
 *
 * @param mood The new mood event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)postMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion;

/**
 * Delete a mood event.
 *
 * @param mood The mood event to be deleted. The currently authenticated user must own the mood event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)deleteMood:(UPMood *)mood completion:(UPBaseEventAPICompletion)completion;

/**
 * Update an existing mood event.
 *
 * @param mood The mood event to be updated.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (void)refreshMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion;

@end

/**
 *  The avaiable types of moods.
 */
typedef NS_ENUM(NSUInteger, UPMoodType)
{
    UPMoodTypeAmazing,
    UPMoodTypePumpedUp,
    UPMoodTypeEnergized,
    UPMoodTypeGood,
    UPMoodTypeMeh,
    UPMoodTypeDragging,
    UPMoodTypeExhausted,
    UPMoodTypeTotallyDone,
};

/**
 *  An event that represents how the user is feeling.
 */
@interface UPMood : UPBaseEvent

/**
 * Create a new mood event.
 *
 * @param type The mood type of new mood event.
 * @param completion Block to be executed upon completion. This block is passed the result or any error information.
 */
+ (UPMood *)moodWithType:(UPMoodType)type title:(NSString *)title;

/**
 *  The type of mood, which controls which icon is used.
 */
@property (nonatomic, assign) UPMoodType type;

@end
