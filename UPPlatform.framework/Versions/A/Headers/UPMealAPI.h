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

/**
 *  Provides an interface for interacting with the user's meals.
 */
@interface UPMealAPI : NSObject

/**
 * Request most recent meal events for the currently authenticated user. The request is made asynchronously.
 *
 * @param limit Maximum number of meals to be retrieved.
 * @param completion Block to be executed upon completion. The block is passed a result array.
 */
+ (void)getMealsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;

/**
 * Request meal events between two points in time for the currently authenticated user.
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

/**
 *  The available sub types of a meal.
 */
typedef NS_ENUM(NSUInteger, UPMealSubType)
{
	UPMealSubTypeBreakfast          = 1,
	UPMealSubTypeLunch              = 2,
	UPMealSubTypeDinner             = 3
};

/**
 *  Represents a single meal, consisting of multiple meal items.
 */
@interface UPMeal : UPBaseEvent

/**
 * Create a new meal event that can be posted to the user's feed.
 *
 * @param title New meal event.
 * @param items The items that constitute the new meal.
 */
+ (UPMeal *)mealWithTitle:(NSString *)title items:(NSArray *)items;

/**
 * Create a new meal event with specifed location that can be posted to the user's feed.
 *
 * @param title The title of the new meal event.
 * @param placeName The name of the location.
 * @param placeLatitude The latitude coordinate.
 * @param placeLongitude The longitude coordinate.
 * @param placeAccuracy The accuracy of the coordinates.
 * @param items The items that constitute the new meal.
 */
+ (UPMeal *)mealWithTitle:(NSString *)title placeName:(NSString *)placeName placeLatitude:(NSNumber *)placeLatitude placeLongitude:(NSNumber *)placeLongitude placeAccuracy:(NSNumber *)placeAccuracy items:(NSArray *)items;

/**
 *  Overall nutrution info for the entire meal.
 */
@property (nonatomic, strong) UPMealNutritionInfo *overallNutritionInfo;

/**
 *  The items of which the meal consists.
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  The name of the place the meal was created.
 */
@property (nonatomic, strong) NSString *placeName;

/**
 *  The latitude of the place the meal was created.
 */
@property (nonatomic, strong) NSNumber *placeLatitude;

/**
 *  The longitude of the place the meal was created.
 */
@property (nonatomic, strong) NSNumber *placeLongitude;

/**
 *  The accuracy of the lat/long of the place the meal was created.
 */
@property (nonatomic, strong) NSNumber *placeAccuracy;

/**
 *  The number of food items in the meal.
 */
@property (nonatomic, strong) NSNumber *foodCount;

/**
 *  The number of drink items in the meal.
 */
@property (nonatomic, strong) NSNumber *drinkCount;

/**
 *  The photo for the meal.
 */
@property (nonatomic, strong) UPImage *photo;

/**
 *  The photo URL for the meal.
 */
@property (nonatomic, strong) NSString *photoURL;

/**
 * The sub type of the meal.
 */
@property (nonatomic, assign) UPMealSubType subType;

@end

/**
 *  Represents nutrition information about a meal or meal item.
 */
@interface UPMealNutritionInfo : NSObject <UPBaseObject>

/**
 *  The total calcium in the meal item.
 */
@property (nonatomic, strong) NSNumber *calcium;

/**
 *  The total calories in the meal item.
 */
@property (nonatomic, strong) NSNumber *calories;

/**
 *  The total carbohydrates in the meal item.
 */
@property (nonatomic, strong) NSNumber *carbohydrates;

/**
 *  The total cholesterol in the meal item.
 */
@property (nonatomic, strong) NSNumber *cholesterol;

/**
 *  The total fat in the meal item.
 */
@property (nonatomic, strong) NSNumber *fat;

/**
 *  The total fiber in the meal item.
 */
@property (nonatomic, strong) NSNumber *fiber;

/**
 *  The total iron in the meal item.
 */
@property (nonatomic, strong) NSNumber *iron;

/**
 *  The total monounsaturated fat in the meal item.
 */
@property (nonatomic, strong) NSNumber *monounsaturatedFat;

/**
 *  The total polyunsaturated fat in the meal item.
 */
@property (nonatomic, strong) NSNumber *polyunsaturatedFat;

/**
 *  The total potassium in the meal item.
 */
@property (nonatomic, strong) NSNumber *potassium;

/**
 *  The total protein in the meal item.
 */
@property (nonatomic, strong) NSNumber *protein;

/**
 *  The total saturated fat in the meal item.
 */
@property (nonatomic, strong) NSNumber *saturatedFat;

/**
 *  The total sodium in the meal item.
 */
@property (nonatomic, strong) NSNumber *sodium;

/**
 *  The total sugar in the meal item.
 */
@property (nonatomic, strong) NSNumber *sugar;

/**
 *  The total unsaturated fat in the meal item.
 */
@property (nonatomic, strong) NSNumber *unsaturatedFat;

/**
 *  The total vitamin A in the meal item.
 */
@property (nonatomic, strong) NSNumber *vitaminA;

/**
 *  The total vitamin C in the meal item.
 */
@property (nonatomic, strong) NSNumber *vitaminC;

@end

/**
 *  The available serving types of a meal item.
 */
typedef NS_ENUM(NSUInteger, UPMealItemServingType)
{
	UPMealItemServingTypePlate		= 1,
	UPMealItemServingTypeCup		= 2,
	UPMealItemServingTypeBowl		= 3,
	UPMealItemServingTypeScale		= 4,
	UPMealItemServingTypeGlass		= 5
};

/**
 *  The available food types of a meal item.
 */
typedef NS_ENUM(NSUInteger, UPMealItemFoodType)
{
	UPMealItemFoodTypeGeneric			= 1,
	UPMealItemFoodTypeRestaurant		= 2,
	UPMealItemFoodTypeBrand				= 3,
	UPMealItemFoodTypePersonal			= 4
};

/**
 *  The available sub types of a meal item.
 */
typedef NS_ENUM(NSUInteger, UPMealItemSubType)
{
	UPMealItemSubTypeDrink              = 1,
	UPMealItemSubTypeFood               = 2
};

/**
 *  A single item making up a portion of a meal.
 */
@interface UPMealItem : NSObject <UPBaseObject>

/**
 * Create a new meal item that can be used inside a meal event.
 *
 * @param name The name of the new meal item.
 * @param description The description of the new meal item.
 * @param amount The amount or quantity of the new meal item.
 * @param measurementUnits The unit of measurement for the new meal item.
 * @param servingType The serving type of the new meal item.
 * @param foodType The food type of the new meal item.
 * @param nutritionInfo The nutrition information for the new item.
 */
+ (UPMealItem *)mealItemWithName:(NSString *)name description:(NSString *)description amount:(NSNumber *)amount measurementUnits:(NSString *)measurementUnits servingType:(UPMealItemServingType)servingType foodType:(UPMealItemFoodType)foodType nutritionInfo:(UPMealNutritionInfo *)nutritionInfo;

/**
 *  The name of the meal item.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The description of the meal item.
 */
@property (nonatomic, strong) NSString *itemDescription;

/**
 *  The amount of this meal item in the overall meal.
 */
@property (nonatomic, strong) NSNumber *amount;

/**
 *  The unit of measurement that the amount represents.
 */
@property (nonatomic, strong) NSString *measurementUnits;

/**
 *  The serving type of the meal item.
 */
@property (nonatomic, assign) UPMealItemServingType servingType;

/**
 *  The food type of the meal item.
 */
@property (nonatomic, assign) UPMealItemFoodType foodType;

/**
 *  The sub type of the meal item (food or drink).
 */
@property (nonatomic, assign) UPMealItemSubType subType;

/**
 *  The category of the meal item.
 */
@property (nonatomic, strong) NSString *category;

/**
 *  The nutrition information of the meal item.
 */
@property (nonatomic, strong) UPMealNutritionInfo *nutritionInfo;

@end

