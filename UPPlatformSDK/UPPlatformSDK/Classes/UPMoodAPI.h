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

@interface UPMoodAPI : NSObject

+ (void)getCurrentMoodWithCompletion:(UPMoodAPICompletion)completion;
+ (void)postMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion;
+ (void)deleteMood:(UPMood *)mood completion:(UPBaseEventAPICompletion)completion;
+ (void)refreshMood:(UPMood *)mood completion:(UPMoodAPICompletion)completion;

@end

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

@interface UPMood : UPBaseEvent

+ (UPMood *)moodWithType:(UPMoodType)type title:(NSString *)title;

@property (nonatomic, assign) UPMoodType type;

@end
