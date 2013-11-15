//
//  HUMealViewController.m
//  HelloUP
//
//  Created by Shadow on 11/15/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "HUMealViewController.h"
#import <UPPlatformSDK/UPPlatformSDK.h>

@interface HUMealViewController ()

@end

@implementation HUMealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMeal];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMeal
{
    // Meal events should be created with one or more meal items. To create a new meal event, we start by specifying nutritional information for a single meal item.
    UPMealNutritionInfo *info = [[UPMealNutritionInfo alloc] init];
    
    info.calories = @130.0;
    info.sugar = @30.0;
    info.carbohydrates = @10.0;
    info.calcium = @80.0;
    
    // Afterwards, we create a new meal item and set its nutritional information.
    UPMealItem *item = [UPMealItem mealItemWithName:@"Granola Bar"
                                        description:@"A fancy granola bar."
                                             amount:@1
                                   measurementUnits:@"bar"
                                        servingType:UPMealItemServingTypePlate
                                           foodType:UPMealItemFoodTypeBrand
                                      nutritionInfo:info];
    
    // Then, we create a new meal event that will hold the meal item we had just created.
    UPMeal *meal = [UPMeal mealWithTitle:@"Delicious Granola Bar"
                                    note:@"It was tasty"
                                   items:@[item]];
    
    meal.photoURL = @"http://studylogic.net/wp-content/uploads/2013/01/burger.jpg";
    
    [UPMealAPI postMeal:meal completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
        
        // Retrieve the meal we just created.
        [self getMealDetailsForMeal:meal];
    }];
}

- (void)getMealDetailsForMeal:(UPMeal *)meal
{
    [UPMealAPI getMealDetails:meal completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
        NSLog(@"%@", meal);
        self.resultLabel.text = meal.title;
        [self.resultLabel sizeToFit];
    }];
}

@end
