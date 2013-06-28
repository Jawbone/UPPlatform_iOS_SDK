//
//  UPBaseEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPURLRequest.h"

@class UPURLResponse, UPBaseEvent, UPSnapshot;

typedef void(^UPBaseEventAPICompletion)(id result, UPURLResponse *response, NSError *error);
typedef void(^UPBaseEventAPIArrayCompletion)(NSArray *results, UPURLResponse *response, NSError *error);
typedef void(^UPBaseEventAPIImageCompletion)(UPImage *image);
typedef void(^UPBaseEventAPISnapshotCompletion)(UPSnapshot *snapshot, UPURLResponse *response, NSError *error);

@interface UPBaseEventAPI : NSObject

+ (void)getEventsOfType:(NSString *)type destinationClass:(Class)destClass completion:(UPBaseEventAPICompletion)completion;
+ (void)postEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;
+ (void)updateEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;
+ (void)refreshEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;
+ (void)deleteEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

@protocol UPBaseObject <NSObject>

- (void)decodeFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeToDictionary;

@end

@interface UPBaseEvent : NSObject <UPBaseObject>

@property (nonatomic, strong) NSString *xid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *timeCreated;
@property (nonatomic, strong) NSDate *timeUpdated;
@property (nonatomic, strong) NSTimeZone *timeZone;

- (NSString *)apiType;

@end

@interface UPSnapshot : NSObject

@property (nonatomic, strong) NSArray *ticks;

+ (UPSnapshot *)snapshotWithArray:(NSArray *)array;

@end

@interface UPSnapshotTick : NSObject

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSNumber *value;

@end
