//
//  UPBodyEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"
#import "UPGenericEventAPI.h"

@class UPBodyEvent, UPURLResponse;

typedef void(^UPBodyEventAPICompletion)(UPBodyEvent *event, UPURLResponse *response, NSError *error);

@interface UPBodyEventAPI : NSObject

+ (void)getBodyEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)postBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion;
+ (void)refreshBodyEvent:(UPBodyEvent *)event completion:(UPBodyEventAPICompletion)completion;
+ (void)deleteBodyEvent:(UPBodyEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

@interface UPBodyEvent : UPGenericEvent

+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note image:(UPImage *)image;
+ (UPBodyEvent *)eventWithTitle:(NSString *)title weight:(NSNumber *)weight bodyFat:(NSNumber *)bodyFat leanMass:(NSNumber *)leanMass bmi:(NSNumber *)bmi note:(NSString *)note imageURL:(NSString *)imageURL;

@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *bodyFat;
@property (nonatomic, strong) NSNumber *leanMass;
@property (nonatomic, strong) NSNumber *bmi;

@end
