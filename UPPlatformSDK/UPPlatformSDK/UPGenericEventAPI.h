//
//  UPGenericEventAPI.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPGenericEvent, UPURLResponse;

typedef void(^UPGenericEventAPICompletion)(UPGenericEvent *event, UPURLResponse *response, NSError *error);

@interface UPGenericEventAPI : NSObject

+ (void)getGenericEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)postGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion;
+ (void)refreshGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion;
+ (void)deleteGenericEvent:(UPGenericEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

@interface UPGenericEvent : UPBaseEvent

+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note image:(UIImage *)image;
+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note imageURL:(NSString *)imageURL;

@property (nonatomic, strong) NSString *verb;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *image;

@end
