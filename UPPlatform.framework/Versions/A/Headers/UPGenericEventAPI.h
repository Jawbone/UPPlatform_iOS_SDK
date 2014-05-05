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

/**
 *  Provides an interface for interacting with generic events.
 */
@interface UPGenericEventAPI : NSObject

/**
 * Get generic events for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)getGenericEventsWithCompletion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Create a new generic event for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)postGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion;

/**
 * Get a generic event for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)refreshGenericEvent:(UPGenericEvent *)event completion:(UPGenericEventAPICompletion)completion;

/**
 * Delete a generic event for the currently authenticated user.
 *
 * @param completion Block to be executed upon completion. This block is passed the results or any error information.
 */
+ (void)deleteGenericEvent:(UPGenericEvent *)event completion:(UPBaseEventAPICompletion)completion;

@end

/**
 *  A generic event represents any event posted to the UP platform that isn't already represented.
 *  This can be used for generic messaging, or events that are specific to 3rd party application (i.e. posting a photo)
 */
@interface UPGenericEvent : UPBaseEvent

/**
 * Create a new generic event with supplied parameters for the currently authenticated user.
 *
 * @param title Title of the new event.
 * @param verb Verb to indicate user action (used in the feed story).
 * @param attributes Set of attributes associated with the event (used in the feed story).
 * @param note Description of the event.
 * @param image Image to include in the event.
 */
+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note image:(UPImage *)image;

/**
 * Create a new generic event with supplied parameters for the currently authenticated user.
 *
 * @param title Title of the new event.
 * @param verb Verb to indicate user action (used in the feed story).
 * @param attributes Set of attributes associated with the event (used in the feed story).
 * @param note Description of the event.
 * @param imageURL URI of the image to include in the event.
 */
+ (UPGenericEvent *)eventWithTitle:(NSString *)title verb:(NSString *)verb attributes:(NSDictionary *)attributes note:(NSString *)note imageURL:(NSString *)imageURL;

/**
 * Verb to indicate user action (used in the feed story).
 */
@property (nonatomic, strong) NSString *verb;

/**
 * Set of attributes associated with the event (used in the feed story).
 */
@property (nonatomic, strong) NSDictionary *attributes;

/**
 * Description of the event.
 */
@property (nonatomic, strong) NSString *note;

/**
 * URI of the event's image.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 * Event image.
 */
@property (nonatomic, strong) UPImage *image;

@end
