//
//  JBMealTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBMealTestViewController.h"

#import "UP.h"

@interface JBMealTestViewController ()

@end

@implementation JBMealTestViewController

- (void)getMeals
{
	[UPMealAPI getMealsWithLimit:5 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		[self showResults:results];
	}];
}

- (void)postMeal
{
	UPMealNutritionInfo *info = [[UPMealNutritionInfo alloc] init];
	info.calories = @(130);
	info.sugar = @(30);
	info.carbohydrates = @(10);
	info.calcium = @(80);
	
	UPMealItem *item = [UPMealItem mealItemWithName:@"Granola Bar" description:@"A fancy granola bar." amount:@(1) measurementUnits:@"bar" servingType:UPMealItemServingTypePlate foodType:UPMealItemFoodTypeBrand nutritionInfo:info];
	UPMeal *meal = [UPMeal mealWithTitle:@"Delicious Granola Bar" note:@"It was tasty" items:@[ item ]];
	meal.photoURL = @"http://studylogic.net/wp-content/uploads/2013/01/burger.jpg";
	
	[UPMealAPI postMeal:meal completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
		[self showResults:meal];
	}];
}

- (void)getMealDetails
{
	[UPMealAPI getMealsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPMealAPI getMealDetails:results[0] completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
				[self showResults:meal];
			}];
		}
	}];
}

- (void)deleteMeal
{
	[UPMealAPI getMealsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPMealAPI deleteMeal:results[0] completion:^(id result, UPURLResponse *response, NSError *error) {
				[self showResults:response.metadata];
			}];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getMeals];
			break;
			
		case 1:
			[self postMeal];
			break;
			
		case 2:
			[self getMealDetails];
			break;
			
		case 3:
			[self deleteMeal];
			break;
			
		default:
			break;
	}
}

@end
