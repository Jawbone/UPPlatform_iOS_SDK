//
//  UPMealAPI.m
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPMealAPI.h"

#import "UPURLRequest.h"
#import "UPURLResponse.h"
#import "UPPlatform.h"
#import "NSDictionary+UPPlatform.h"

static NSString *kMealType = @"meals";

@implementation UPMealAPI

+ (void)getMealsWithLimit:(NSUInteger)limit completion:(UPBaseEventAPIArrayCompletion)completion
{
	if (limit == 0) limit = 10;
	NSDictionary *params = @{ @"limit" : @(limit) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/meals", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPMeal *meal = [[UPMeal alloc] init];
				[meal decodeFromDictionary:jsonItem];
				
				[results addObject:meal];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)getMealsFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate completion:(UPBaseEventAPIArrayCompletion)completion
{
	NSDictionary *params = @{ @"start_time" : @([startDate timeIntervalSince1970]), @"end_time" : @([endDate timeIntervalSince1970]) };
	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:[NSString stringWithFormat:@"nudge/api/%@/users/@me/meals", [UPPlatform currentPlatformVersion]] params:params];
    
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		
		NSMutableArray *results = nil;
		if (error == nil)
		{
			results = [NSMutableArray array];
			NSArray *jsonItems = response.data[@"items"];
			for (NSDictionary *jsonItem in jsonItems)
			{
				UPMeal *meal = [[UPMeal alloc] init];
				[meal decodeFromDictionary:jsonItem];
				
				[results addObject:meal];
			}
		}
        
        if (completion != nil) completion(results, response, error);
	}];
}

+ (void)postMeal:(UPMeal *)meal completion:(UPMealAPICompletion)completion
{
	[UPBaseEventAPI postEvent:meal completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(meal, response, error);
	}];
}

+ (void)getMealDetails:(UPMeal *)meal completion:(UPMealAPICompletion)completion
{
	[UPBaseEventAPI refreshEvent:meal completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(meal, response, error);
	}];
}

+ (void)deleteMeal:(UPMeal *)meal completion:(UPBaseEventAPICompletion)completion
{
	[UPBaseEventAPI deleteEvent:meal completion:^(id result, UPURLResponse *response, NSError *error) {
		if (completion != nil) completion(result, response, error);
	}];
}

@end

@implementation UPMeal

+ (UPMeal *)mealWithTitle:(NSString *)title items:(NSArray *)items
{
	return [self mealWithTitle:title placeName:nil placeLatitude:nil placeLongitude:nil placeAccuracy:nil items:items];
}

+ (UPMeal *)mealWithTitle:(NSString *)title placeName:(NSString *)placeName placeLatitude:(NSNumber *)placeLatitude placeLongitude:(NSNumber *)placeLongitude placeAccuracy:(NSNumber *)placeAccuracy items:(NSArray *)items
{
	UPMeal *meal = [[UPMeal alloc] init];
	
	meal.title = title;
	meal.placeName = placeName;
	meal.placeLatitude = placeLatitude;
	meal.placeLongitude = placeLongitude;
	meal.placeAccuracy = placeAccuracy;
	meal.items = items;
	
	return meal;
}

- (NSString *)apiType
{
	return kMealType;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	[super decodeFromDictionary:dictionary];
	
	NSDictionary *details = dictionary[@"details"];
	
	self.placeName = [dictionary stringForKey:@"place_name"];
	self.placeLatitude = [dictionary numberForKey:@"place_lat"];
	self.placeLongitude = [dictionary numberForKey:@"place_lon"];
	self.placeAccuracy = [details numberForKey:@"accuracy"];
	self.foodCount = [details numberForKey:@"num_foods"];
	self.drinkCount = [details numberForKey:@"num_drinks"];
	self.title = [dictionary stringForKey:@"note"];
	if ([dictionary stringForKey:@"image"].length > 0) self.photoURL = [NSString stringWithFormat:@"%@%@", [UPPlatform basePlatformURL], [dictionary stringForKey:@"image"]];
	
	UPMealNutritionInfo *nutrition = [[UPMealNutritionInfo alloc] init];
	[nutrition decodeFromDictionary:details];
	self.overallNutritionInfo = nutrition;
	
	NSArray *itemsJSON = dictionary[@"items"][@"items"];
	
	if (itemsJSON != nil)
	{
		// These are only parsed when viewing a single meal's details
		NSMutableArray *items = [NSMutableArray array];
		for (NSDictionary *itemDict in itemsJSON)
		{
			UPMealItem *item = [[UPMealItem alloc] init];
			[item decodeFromDictionary:itemDict];
			[items addObject:item];
		}
		self.items = items;
	}
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dict = [[super encodeToDictionary] mutableCopy];
	
	if (self.title != nil) [dict setObject:self.title forKey:@"note"];
	if (self.placeName != nil) [dict setObject:self.placeName forKey:@"place_name"];
	if (self.placeLatitude != nil) [dict setObject:self.placeLatitude forKey:@"place_lat"];
	if (self.placeLongitude != nil) [dict setObject:self.self.placeLongitude forKey:@"place_lon"];
	if (self.placeAccuracy != nil) [dict setObject:self.placeAccuracy forKey:@"place_acc"];
	if (self.photoURL != nil) [dict setObject:self.photoURL forKey:@"image_url"];
	
	if (self.items.count > 0)
	{
		NSMutableArray *itemDictionaries = [NSMutableArray array];
		for (UPMealItem *item in self.items)
		{
			[itemDictionaries addObject:[item encodeToDictionary]];
		}
		
		NSString *itemsJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:itemDictionaries options:0 error:nil] encoding:NSUTF8StringEncoding];
		[dict setObject:itemsJSON forKey:@"items"];
	}
	
	return dict;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPMeal: { xid: %@, title: %@, date: %@, placeName: %@, placeLatitude: %@, placeLongitude: %@, placeAccuracy: %@, foodCount: %@, drinkCount: %@, photoURL: %@, overallNutritionInfo: %@, items: %@ }", self.xid, self.title, self.date, self.placeName, self.placeLatitude, self.placeLongitude, self.placeAccuracy, self.foodCount, self.drinkCount, self.photoURL, self.overallNutritionInfo, self.items];
}

@end

@implementation UPMealNutritionInfo

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.calcium = [dictionary numberForKey:@"calcium"];
	self.calories = [dictionary numberForKey:@"calories"];
	self.carbohydrates = [dictionary numberForKey:@"carbohydrate"];
	self.cholesterol = [dictionary numberForKey:@"cholesterol"];
	self.fat = [dictionary numberForKey:@"fat"];
	self.fiber = [dictionary numberForKey:@"fiber"];
	self.iron = [dictionary numberForKey:@"iron"];
	self.monounsaturatedFat = [dictionary numberForKey:@"monounsaturated_fat"];
	self.polyunsaturatedFat = [dictionary numberForKey:@"polyunsaturated_fat"];
	self.potassium = [dictionary numberForKey:@"potassium"];
	self.protein = [dictionary numberForKey:@"protein"];
	self.saturatedFat = [dictionary numberForKey:@"saturated_fat"];
	self.sodium = [dictionary numberForKey:@"sodium"];
	self.sugar = [dictionary numberForKey:@"sugar"];
	self.unsaturatedFat = [dictionary numberForKey:@"unsaturated_fat"];
	self.vitaminA = [dictionary numberForKey:@"vitamin_a"];
	self.vitaminC = [dictionary numberForKey:@"vitamin_c"];
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	if (self.calcium != nil) [dictionary setObject:self.calcium forKey:@"calcium"];
	if (self.calories != nil) [dictionary setObject:self.calories forKey:@"calories"];
	if (self.carbohydrates != nil) [dictionary setObject:self.carbohydrates forKey:@"carbohydrate"];
	if (self.cholesterol != nil) [dictionary setObject:self.cholesterol forKey:@"cholesterol"];
	if (self.fat != nil) [dictionary setObject:self.fat forKey:@"fat"];
	if (self.fiber != nil) [dictionary setObject:self.fiber forKey:@"fiber"];
	if (self.iron != nil) [dictionary setObject:self.iron forKey:@"iron"];
	if (self.monounsaturatedFat != nil) [dictionary setObject:self.monounsaturatedFat forKey:@"monounsaturated_fat"];
	if (self.polyunsaturatedFat != nil) [dictionary setObject:self.polyunsaturatedFat forKey:@"polyunsaturated_fat"];
	if (self.potassium != nil) [dictionary setObject:self.potassium forKey:@"potassium"];
	if (self.protein != nil) [dictionary setObject:self.protein forKey:@"protein"];
	if (self.saturatedFat != nil) [dictionary setObject:self.saturatedFat forKey:@"saturated_fat"];
	if (self.sodium != nil) [dictionary setObject:self.sodium forKey:@"sodium"];
	if (self.sugar != nil) [dictionary setObject:self.sugar forKey:@"sugar"];
	if (self.unsaturatedFat != nil) [dictionary setObject:self.unsaturatedFat forKey:@"unsaturated_fat"];
	if (self.vitaminA != nil) [dictionary setObject:self.vitaminA forKey:@"vitamin_a"];
	if (self.vitaminC != nil) [dictionary setObject:self.vitaminC forKey:@"vitamin_c"];
	
	return dictionary;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPMealNutritionInfo: { calcium: %@, calories: %@, carbohydrates: %@, cholesterol: %@, fat: %@, fiber: %@, iron: %@, monounsaturatedFat: %@, polyunsaturatedFat: %@, potassium: %@, protein: %@, saturatedFat: %@, sodium: %@, sugar: %@, unsaturatedFat: %@, vitaminA: %@, vitaminC: %@ }", self.calcium, self.calories, self.carbohydrates, self.cholesterol, self.fat, self.fiber, self.iron, self.monounsaturatedFat, self.polyunsaturatedFat, self.potassium, self.protein, self.saturatedFat, self.sodium, self.sugar, self.unsaturatedFat, self.vitaminA, self.vitaminC];
}

@end

@implementation UPMealItem

+ (UPMealItem *)mealItemWithName:(NSString *)name description:(NSString *)description amount:(NSNumber *)amount measurementUnits:(NSString *)measurementUnits servingType:(UPMealItemServingType)servingType foodType:(UPMealItemFoodType)foodType nutritionInfo:(UPMealNutritionInfo *)nutritionInfo
{
	UPMealItem *item = [[UPMealItem alloc] init];
	
	item.name = name;
	item.itemDescription = description;
	item.amount = amount;
	item.measurementUnits = measurementUnits;
	item.servingType = servingType;
	item.foodType = foodType;
	item.nutritionInfo = nutritionInfo;
	
	return item;
}

- (void)decodeFromDictionary:(NSDictionary *)dictionary
{
	self.name = [dictionary stringForKey:@"name"];
	self.itemDescription = [dictionary stringForKey:@"description"];
	self.amount = [dictionary numberForKey:@"amount"];
	self.measurementUnits = [dictionary stringForKey:@"measurement"];
	self.servingType = [self servingTypeFromString:[dictionary stringForKey:@"type"]];
	self.foodType = [[dictionary numberForKey:@"sub_type"] intValue];
	self.category = [dictionary stringForKey:@"category"];
	
	UPMealNutritionInfo *nutrition = [[UPMealNutritionInfo alloc] init];
	[nutrition decodeFromDictionary:dictionary];
	self.nutritionInfo = nutrition;
}

- (NSDictionary *)encodeToDictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	if (self.name != nil) [dictionary setObject:self.name forKey:@"name"];
	if (self.itemDescription != nil) [dictionary setObject:self.itemDescription forKey:@"description"];
	if (self.amount != nil) [dictionary setObject:self.amount forKey:@"amount"];
	if (self.measurementUnits != nil) [dictionary setObject:self.measurementUnits forKey:@"measurement"];
	if (self.servingType != 0) [dictionary setObject:@(self.servingType) forKey:@"type"];
	if (self.foodType != 0) [dictionary setObject:@(self.foodType) forKey:@"food_type"];
	if (self.category != nil) [dictionary setObject:self.category forKey:@"category"];
	if (self.nutritionInfo != nil) [dictionary addEntriesFromDictionary:[self.nutritionInfo encodeToDictionary]];
	
	return dictionary;
}

- (UPMealItemServingType)servingTypeFromString:(NSString *)type
{
	if ([type isEqualToString:@"cup"]) return UPMealItemServingTypeCup;
	else if ([type isEqualToString:@"bowl"]) return UPMealItemServingTypeBowl;
	else if ([type isEqualToString:@"scale"]) return UPMealItemServingTypeScale;
	else if ([type isEqualToString:@"glass"]) return UPMealItemServingTypeGlass;
	
	return UPMealItemServingTypePlate;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"UPMealItem: { name: %@, itemDescription: %@, amount: %@, measurementUnits: %@, servingType: %d, foodType: %d, category: %@, nutritionInfo: %@ }", self.name, self.itemDescription, self.amount, self.measurementUnits, (int)self.servingType, (int)self.foodType, self.category, self.nutritionInfo ];
}

@end
