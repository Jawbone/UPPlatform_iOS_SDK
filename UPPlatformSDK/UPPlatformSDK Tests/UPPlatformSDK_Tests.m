//
//  UPPlatformSDK_Tests.m
//  UPPlatformSDK Tests
//
//  Created by Shadow on 10/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UPMealAPI.h"

@interface UPPlatformSDK_Tests : XCTestCase

@end

@implementation UPPlatformSDK_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateMealItem
{
    // Create a new meal nutrition dictionary.
    UPMealNutritionInfo *mealNutritionInfo = [[UPMealNutritionInfo alloc] init];

    mealNutritionInfo.calories = @100.0;
    
    // Create a new meal item.
    UPMealItem *testMealitem = [UPMealItem mealItemWithName:@"testName"
                                                description:@"testDescription"
                                                     amount:@1
                                           measurementUnits:@"testUnit"
                                                servingType:UPMealItemServingTypeBowl
                                                   foodType:UPMealItemFoodTypeGeneric
                                              nutritionInfo:mealNutritionInfo];
    
    XCTAssertNotNil(testMealitem, @"New meal item is nil.");
}

@end
