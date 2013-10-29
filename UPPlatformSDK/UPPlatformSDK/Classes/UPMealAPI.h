//
//  UPMealAPI.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseEventAPI.h"

@class UPMeal, UPURLResponse, UPMealNutritionInfo, UPMealItem;

typedef void(^UPMealAPICompletion)(UPMeal *meal, UPURLResponse *response, NSError *error);

@interface UPMealAPI : NSObject

/**
 * Request most recent meal events for the currently authenticated user. The request is made asynchronously.
 *
 * @param limit Maximum number of meals to be retrieved.
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)getMealsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request meal events between two points in time for the currently authenticated user. The request is made
 * asynchronously.
 *
 * @param startDate
 * @param endDate
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)getMealsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Post a meal event to the feed of the currently authenticated user.
 *
 * @param meal New meal event.
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)postMeal:(UPMeal *)meal completion:(UPMealAPICompletion)completion;

/**
 * Request details about a meal event on the currently authenticated user's feed.
 *
 * @param meal New meal event.
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)getMealDetails:(UPMeal *)meal completion:(UPMealAPICompletion)completion;

/**
 * Delete a meal event that's currently on the user's timeline.
 *
 * @param meal New meal event.
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)deleteMeal:(UPMeal *)meal completion:(UPBaseEventAPICompletion)completion;

@end

@interface UPMeal : UPBaseEvent

/**
 * Create a new meal event that can be posted to the user's feed.
 *
 * @param title New meal event.
 * @param note The note for the meal event.
 * @param items The items that constitute the new meal.
 */
+ (UPMeal *)mealWithTitle:(NSString *)title note:(NSString *)note items:(NSArray *)items;

/**
 * Create a new meal event with specifed location that can be posted to the user's feed.
 *
 * @param title The title of the new meal event.
 * @param note The note for the meal event.
 * @param placeName The name of the location.
 * @param placeLatitude The latitude coordinate.
 * @param placeLongitude The longitude coordinate.
 * @param placeAccuracy The accuracy of the coordinates.
 * @param items The items that constitute the new meal.
 */
+ (UPMeal *)mealWithTitle:(NSString *)title note:(NSString *)note placeName:(NSString *)placeName placeLatitude:(NSNumber *)placeLatitude placeLongitude:(NSNumber *)placeLongitude placeAccuracy:(NSNumber *)placeAccuracy items:(NSArray *)items;

@property (nonatomic, strong) UPMealNutritionInfo *overallNutritionInfo;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSNumber *placeLatitude;
@property (nonatomic, strong) NSNumber *placeLongitude;
@property (nonatomic, strong) NSNumber *placeAccuracy;
@property (nonatomic, strong) NSNumber *foodCount;

/// TODO: What is this drinkCount?
@property (nonatomic, strong) NSNumber *drinkCount;
@property (nonatomic, strong) NSString *note;

/// The photo for the meal.
@property (nonatomic, strong) UPImage *photo;

/// The URL for the photo of the meal.
@property (nonatomic, strong) NSString *photoURL;

@end

@interface UPMealNutritionInfo : NSObject <UPBaseObject>

@property (nonatomic, strong) NSNumber *calcium;
@property (nonatomic, strong) NSNumber *calories;
@property (nonatomic, strong) NSNumber *carbohydrates;
@property (nonatomic, strong) NSNumber *cholesterol;
@property (nonatomic, strong) NSNumber *fat;
@property (nonatomic, strong) NSNumber *fiber;
@property (nonatomic, strong) NSNumber *iron;
@property (nonatomic, strong) NSNumber *monounsaturatedFat;
@property (nonatomic, strong) NSNumber *polyunsaturatedFat;
@property (nonatomic, strong) NSNumber *potassium;
@property (nonatomic, strong) NSNumber *protein;
@property (nonatomic, strong) NSNumber *saturatedFat;
@property (nonatomic, strong) NSNumber *sodium;
@property (nonatomic, strong) NSNumber *sugar;
@property (nonatomic, strong) NSNumber *unsaturatedFat;
@property (nonatomic, strong) NSNumber *vitaminA;
@property (nonatomic, strong) NSNumber *vitaminC;

@end

typedef NS_ENUM(NSUInteger, UPMealItemServingType)
{
	UPMealItemServingTypePlate		= 1,
	UPMealItemServingTypeCup		= 2,
	UPMealItemServingTypeBowl		= 3,
	UPMealItemServingTypeScale		= 4,
	UPMealItemServingTypeGlass		= 5
};

typedef NS_ENUM(NSUInteger, UPMealItemFoodType)
{
	UPMealItemFoodTypeGeneric			= 1,
	UPMealItemFoodTypeRestaurant		= 2,
	UPMealItemFoodTypeBrand				= 3,
	UPMealItemFoodTypePersonal			= 4
};

@interface UPMealItem : NSObject <UPBaseObject>

/**
 * Create a new meal item that can be used inside a meal event.
 *
 * @param name The name of the new meal item.
 * @param description The description of the new meal item.
 * @param amount The amount or quantity of the new meal item.
 * @param measurementUnits The unit of measurement for the new meal item.
 * @param servingType The serving type of the new meal item. TODO: What is serving type?
 * @param foodType The food type of the new meal item.
 * @param nutritionInfo The nutrition information for the new item.
 */
+ (UPMealItem *)mealItemWithName:(NSString *)name description:(NSString *)description amount:(NSNumber *)amount measurementUnits:(NSString *)measurementUnits servingType:(UPMealItemServingType)servingType foodType:(UPMealItemFoodType)foodType nutritionInfo:(UPMealNutritionInfo *)nutritionInfo;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *measurementUnits;
@property (nonatomic, assign) UPMealItemServingType servingType;
@property (nonatomic, assign) UPMealItemFoodType foodType;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) UPMealNutritionInfo *nutritionInfo;

@end

