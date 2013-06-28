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

+ (void)getMealsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion;
+ (void)getMealsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion;

+ (void)postMeal:(UPMeal *)meal completion:(UPMealAPICompletion)completion;
+ (void)getMealDetails:(UPMeal *)meal completion:(UPMealAPICompletion)completion;
+ (void)deleteMeal:(UPMeal *)meal completion:(UPBaseEventAPICompletion)completion;

@end

@interface UPMeal : UPBaseEvent

+ (UPMeal *)mealWithTitle:(NSString *)title note:(NSString *)note items:(NSArray *)items;
+ (UPMeal *)mealWithTitle:(NSString *)title note:(NSString *)note placeName:(NSString *)placeName placeLatitude:(NSNumber *)placeLatitude placeLongitude:(NSNumber *)placeLongitude placeAccuracy:(NSNumber *)placeAccuracy items:(NSArray *)items;

@property (nonatomic, strong) UPMealNutritionInfo *overallNutritionInfo;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSNumber *placeLatitude;
@property (nonatomic, strong) NSNumber *placeLongitude;
@property (nonatomic, strong) NSNumber *placeAccuracy;
@property (nonatomic, strong) NSNumber *foodCount;
@property (nonatomic, strong) NSNumber *drinkCount;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) UPImage *photo;
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

