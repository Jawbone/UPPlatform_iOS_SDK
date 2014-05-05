//
//  UPBaseEventAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPURLRequest.h"

@class UPURLResponse, UPBaseEvent;

typedef void(^UPBaseEventAPICompletion)(id result, UPURLResponse *response, NSError *error);
typedef void(^UPBaseEventAPIArrayCompletion)(NSArray *results, UPURLResponse *response, NSError *error);
typedef void(^UPBaseEventAPIImageCompletion)(UPImage *image);

/**
 *  The base event API provides a common interface for event management.
 */
@interface UPBaseEventAPI : NSObject

/**
 *  Gets events of a specific type.
 *
 *  @param type       The API type used in the GET request (i.e. moves, sleeps)
 *  @param destClass  The destination class to map the resulting objects
 *  @param completion The completion block, which provides the result, full response, and error.
 */
+ (void)getEventsOfType:(NSString *)type destinationClass:(Class)destClass completion:(UPBaseEventAPICompletion)completion;

/**
 *  Posts a new event to the UP platform.
 *
 *  @param event      The event to POST.
 *  @param completion The completion block, which provides the result, full response, and error.
 */
+ (void)postEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;

/**
 *  Updates an existing event on the UP platform.
 *
 *  @param event      The event to POST.
 *  @param completion The completion block, which provides the result, full response, and error.
 */
+ (void)updateEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;

/**
 *  Requests a single event, based on an xid.
 *
 *  @param event      The event to GET.
 *  @param completion The completion block, which provides the result, full response, and error.
 */
+ (void)refreshEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;

/**
 *  Deletes a single event from the UP platform.
 *
 *  @param event      The event to DELETE.
 *  @param completion The completion block, which provides the result, full response, and error.
 */
+ (void)deleteEvent:(UPBaseEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

/**
 *  The base protocol for serialization and deserialization of UP objects.
 */
@protocol UPBaseObject <NSObject>

/**
 *  Decodes an object from a JSON dictionary.
 */
- (void)decodeFromDictionary:(NSDictionary *)dictionary;

/**
 *  Encodes an object to a JSON dictionary.
 */
- (NSDictionary *)encodeToDictionary;

@end

/**
 *  The base class for events in the UP platform.
 */
@interface UPBaseEvent : NSObject <UPBaseObject>

/**
 *  The unique identifier of the event.
 */
@property (nonatomic, strong) NSString *xid;

/**
 *  The title of the event.
 */
@property (nonatomic, strong) NSString *title;

/**
 *  The date the event occurred.
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  The time the event was created.
 */
@property (nonatomic, strong) NSDate *timeCreated;

/**
 *  The time the event was last updated.
 */
@property (nonatomic, strong) NSDate *timeUpdated;

/**
 *  The time zone the event was created.
 */
@property (nonatomic, strong) NSTimeZone *timeZone;

/**
 *  The API type of the event, used by the events API.
 */
- (NSString *)apiType;

/**
 *  Decodes an object from a JSON dictionary.
 */
- (void)decodeFromDictionary:(NSDictionary *)dictionary;

/**
 *  Encodes an object to a JSON dictionary.
 */
- (NSDictionary *)encodeToDictionary;

@end
