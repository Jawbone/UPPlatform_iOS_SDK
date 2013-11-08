![image](https://d3osil7svxrrgt.cloudfront.net/static/www/logos/jawbone/jawbone-logo-lowres.png)
# UP Platform iOS/OS X SDK

## Overview

This SDK provides an Objective-C interface for integrating iOS and Mac OS X apps with the [UP Platform](https://jawbone.com/up/platform). It handles authentication using OAuth 2.0 via a UIWebView and provides simple interfaces for making requests to the platform's REST endpoints.

## Requirements

The only requirements to start developing with the UP iOS SDK are OS X Mavericks, Xcode 5 and iOS 7. It is recommended that you upgrade to [OS X Mavericks](https://itunes.apple.com/us/app/os-x-mavericks/id675248567?mt=12#), [Xcode 5](http://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12) and [iOS 7](https://developer.apple.com/ios7/) if you haven't done so already.

You will need to have access to an existing Jawbone UP user account in order to authenticate with the UP Platform. New accounts can be created at [jawbone.com/start/signup](http://jawbone.com/start/signup).

## Table of Contents

- [Getting Started](#getting-started)
  - [Obtain your OAuth Credentials](#generate-your-oauth-credentials)
  - [Download the Jawbone UP iOS SDK](#download-the-jawbone-up-ios-sdk)
  - [Run the Sample App](#running-the-sample-app)
  - [Add the iOS SDK to Your Project](#add-the-sdk-to-your-project)
- [Documentation](#documentation)
  - [User](#user-information)
  - [Sleep](#sleeps)
  - [Mood](#moods)
  - [Meals](#meals)
  - [Workouts](#workouts)
- [Demo Application](#demo-application)
- [Unit Tests](#unit-tests)
- [Additional Resources](#additional-resources)
- [Credits](#credits)
- [License](#license)

## Getting Started

#### Obtain Your OAuth Credentials

Sign into the [Jawbone UP Developer Portal](http://developers.jawbone.com) using your Jawbone UP account. If you do not have an account you can create one by going to [jawbone.com/start/signup](https://jawbone.com/start/signup).

Register your organization by pressing "Manage Account".

Follow the instructions to create a new app and get your OAuth **Client ID** and **App Secret** keys that you will use to authenticate with the UP Platform.

![image](Documentation/developer_snapshot.png)

#### Download the Jawbone UP iOS SDK.

You can download the latest iOS SDK release via the link below or clone it directly from this GitHub repository.

**Option 1:** Download UP iOS SDK v1.0.0 (November 2013)  
http://github.com/jawbone/jawbone-up-ios-sdk/releases/1.0.0

**Option 2:** Clone this repository from GitHub  
`git clone git@github.com:Jawbone/jawbone-up-ios-sdk.git`

#### Run the Sample App

The Jawbone UP iOS SDK comes with a sample iOS app that you can use to authenticate with the UP Platform and start interacting with a Jawbone UP account.

You can find and open the PlatformTest project in `UPPlatformSDK/PlatformTest/PlatformTest.xcodeproj`.

#### Add the iOS SDK to Your Project

* Drag `UPPlatformSDK.xcodeproj` into your own Xcode project or workspace.

![image](Documentation/install_1.png)

* Under Build Phases, add either `libUPPlatformSDK.a` or `libUPPlatformSDK-OSX.a` to the linked libraries, depending on your platform.

![image](Documentation/install_2.png)

* Under Build Settings, add the UPPlatformSDK (i.e. `../UPPlatformSDK/UPPlatformSDK`) directory to the Header Search Paths recursively.

![image](Documentation/install_3.png)

* Under Build Settings, add `-all_load` to Other Linker Flags.

![image](Documentation/install_4.png)

* Drag `UPPlatformSDK.bundle` into your project's resources.

![image](Documentation/install_5.png)

#### Authentication

Authentication is handled using the shared `UPPlatform` object.

First, to validate that an existing session is still valid, call `validateSessionWithCompletion:`. If the `session` object passed to the completion block is not `nil`, the session is valid and API requests can be made.

*NOTE: I only added this because when requesting tokens from multiple clients (i.e. Simulator and iPhone), the previously requested tokens become invalid. We should fix this.*

To start a new session, using the `startSessionWithClientID:clientSecret:authScope:completion:` method.

	[[UPPlatform sharedPlatform] startSessionWithClientID:@"MY_CLIENT_ID" clientSecret:@"MY_CLIENT_SECRET" authScope:(UPPlatformAuthScopeExtendedRead | UPPlatformAuthScopeMoveRead) completion:^(UPSession *session, NSError *error) {
		// If session != nil we can begin making API requests.
	}];
	
See `UPPlatform.h` for all available authScopes.

#### API Requests

Once a valid session has been established, there are a few ways to create API requests. You can use either the provided objects that encapsulate most of the available endpoints, or you can create custom requests.

#### API Objects

The API Objects are the simplest way to create requests to the REST platform. They take creating the network requests and parsing the resulting JSON into `NSObject`s. Here are a few examples:

##### Get the current user's information

	[UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
		// Do something with the user
	}];
	
##### Get the user's past 14 moves

	[UPMoveAPI getMovesWithLimit:14 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		// Do something with the array of UPMove objects
	}];
	
##### Post a new body event to UP

	UPBodyEvent *bodyEvent = [UPBodyEvent eventWithTitle:@"160 lbs." weight:@(72.5748) bodyFat:@(20) leanMass:@(20) bmi:@(22) note:@"Weigh-in created by My App." image:nil];
	
	[UPBodyEventAPI bodyEvent completion:^(UPBodyEvent *event, UPURLResponse *response, NSError *error) {
		// Event was created and updated with an xid
	}];
	
*Note: All units (weight, distance) are in metric.*

### Custom Requests

Custom API Requests can also be made using the `UPURLRequest` object, which is what the API Objects also use. This allows you to make a request to any endpoint, giving any parameters, and receiving a resulting JSON object. Here are a few examples:

##### Get the current user's information

	UPURLRequest *request = [UPURLRequest getRequestWithEndpoint:@"nudge/api/users/@me" params:nil];
	
    [[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
        // The resulting response.data is an NSDictionary with the JSON results
    }];
    
##### Post a new mood to UP

	NSDictionary *params = @{ @"title" : @"I feel great!", @"sub_type" : @(1), @"tz" : [NSTimeZone localTimeZone].name };
	
	UPURLRequest *request = [UPURLRequest postRequestWithEndpoint:@"nudge/api/users/@me/mood" params:params];
	
	[[UPPlatform sharedPlatform] sendRequest:request completion:^(UPURLRequest *request, UPURLResponse *response, NSError *error) {
		// The resulting response.data is an NSDictionary describing the created mood
	}];
	
# Documentation

## User Information

### Get detailed information about the user.

``` objective-c
[UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
	// Your code to process returned UPUser object.
}];

```

### Get list of friends (identifiers)

``` objective-c
[UPUserAPI getFriendsWithCompletion:^(NSArray *friends, UPURLResponse *response, NSError *error) {
	// Your code here to process an array of UPUser objects.
}];
```

### Get the user's trends

``` objective-c
[UPUserAPI getTrendsWithEndDate:nil
                      rangeType:UPUserTrendsRangeTypeDays 
                  rangeDuration:10U
                     bucketSize:UPUserTrendsBucketSizeDays 
                     completion:^(NSArray *trends, UPURLResponse *response, NSError *error) {
	// Your code here to process an array of UPTrend objects.
}];
```

## Moves

### Get the user's move list (paginated by date or by a timestamp).

``` objective-c
[UPMoveAPI getMovesWithLimit:10U completion:^(NSArray *moves, UPURLResponse *response, NSError *error) {
	// Your code here to process an array of UPMove objects.
}];
```

### Get the information about a specific move.

``` objective-c
// TODO: What is the code here?
```

### Get the user's move graph.
![image](Documentation/moves.png)

You can request a visualization of the user's moves data as a 560x300 PNG image with a transparent background.
``` objective-c
[UPMoveAPI getMoveGraphImage:move completion:^(UIImage *image) {
	// Your code here to process the graph image.
}];
```
*NOTE: This data is off Andrew's feed. I can take it off if he minds.*
### Get move intensity.
``` objective-c
// TODO: How do you do this in code?
```

## Workouts

### Get the user's workout list (paginated by date or by a timestamp).

``` objective-c
[UPWorkoutAPI getWorkoutsWithLimit:10U completion:^(NSArray *workouts, UPURLResponse *response, NSError *error) {
	// Your code here to process an array of UPWorkout objects.
}];
```

### Create a new workout.

We can start by creating a new workout event.

``` objective-c
UPWorkout *workout = [UPWorkout workoutWithType:UPWorkoutTypeBike
                                      startTime:startTime
                                        endTime:endTime
                                      intensity:UPWorkoutIntensityEasy
                                 caloriesBurned:@300];
                                 
workout.distance = @7;
workout.imageURL = @"http://jaredsurnamer.files.wordpress.com/2011/11/116223-magic-marker-icon-sports-hobbies-people-man-runner.png";
```

We can then post this workout event to the user's feed.

``` objective-c
[UPWorkoutAPI postWorkout:workout completion:^(UPWorkout *workout, UPURLResponse *response, NSError *error) {
	// Your completion code here.
}];
```

### Get the user's workout graph.

![image](Documentation/workouts.png)

You can request a visualization of the user's workout data as a 560x300 PNG image with a transparent background.

``` objective-c
[UPWorkoutAPI getWorkoutGraphImage:workout completion:^(UIImage *image) {
	// Your code here to use the graph image.
}];
```

NOTE: This data is off Christian's feed. I can take it off if he minds.

### Get workout intensity.

``` objective-c
// TODO: What is the code here?
```

## Sleeps

### Get the user's recent sleep events.

``` objective-c
[UPSleepAPI getSleepsWithLimit:10U completion:^(NSArray *sleeps, UPURLResponse *response, NSError *error) {
	// Your code here to process an array of UISleep objects.
}];
```

### Get the information about a specific sleep event.

``` objective-c
// TODO: What is the code here?
```

### Get the user's sleep graph.
![image](Documentation/sleep.png)

You can request a visualization of the user's sleep data as a 560x300 PNG image with a transparent background.
``` objective-c
[UPSleepAPI getSleepGraphImage:sleep completion:^(UIImage *image) {
	// Your code here to handle the graph image.
}];
```
*NOTE: This data is off Christian's feed. I can take it off if he minds.*
### Get sleep phases.
``` objective-c
// TODO: What is the code here?
```
## Meals

### Get the user's recent meal events.

``` objective-c
[UPMealAPI getMealsWithLimit:5U completion:^(NSArray *meals, UPURLResponse *response, NSError *error) {
	// Your code here to process the meals array.
}];
```

### Create a new meal

Meal events should be created with one or more meal items. To create a new meal event, we start by specifying nutritional information for a single meal item.

``` objective-c
UPMealNutritionInfo *info = [[UPMealNutritionInfo alloc] init];

info.calories = @130;
info.sugar = @30;
info.carbohydrates = @10;
info.calcium = @80;
```

Afterwards, we create a new meal item and set its nutritional information.
	
``` objective-c
UPMealItem *item = [UPMealItem mealItemWithName:@"Granola Bar" 
                                    description:@"A fancy granola bar."
                                         amount:@1 
                               measurementUnits:@"bar"
                                    servingType:UPMealItemServingTypePlate 
                                       foodType:UPMealItemFoodTypeBrand 
                                 nutritionInfo:info];
```

Then, we create a new meal event that will hold the meal item we had just created.

``` objective-c
UPMeal *meal = [UPMeal mealWithTitle:@"Delicious Granola Bar"
                                note:@"It was tasty" 
                               items:@[item]];
                               
meal.photoURL = @"http://studylogic.net/wp-content/uploads/2013/01/burger.jpg";
```

Finally, let's post a new event on the user's feed with our new meal!

``` objective-c	
[UPMealAPI postMeal:meal completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
	// Your code here to process the meal object.
}];
```

### Get the information about a specific meal.

``` objective-c
[UPMealAPI getMealDetails:meal completion:^(UPMeal *meal, UPURLResponse *response, NSError *error) {
	// Your code here to process the meal object.
}];
```

## Moods

### Get the user's mood.

``` objective-c
[UPMoodAPI getCurrentMoodWithCompletion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
	[self showResults:mood];
}];
```

### Record the user's mood.

To set the user's mood we first need to create a new UPMood object.

``` objective-c
UPMood *newMood = [UPMood moodWithType:UPMoodTypePumpedUp title:@"I'm pumped!"];
```

Then, we can post the new UPMood object to the user's feed.

``` objective-c
[UPMoodAPI postMood:newMood completion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
	// Your code goes here.
}];
```

### Get a mood event.

``` objective-c
// TODO: What is the code here?
```

### Delete a mood event.

``` objective-c
[UPMoodAPI deleteMood:mood completion:^(id result, UPURLResponse *response, NSError *error) {
	// Your code goes here.
}];
```

# Unit Tests

The SDK ships with a suite of XCTest unit tests that cover the API functionality. You can run the tests by opening the UP iOSK SDK project in Xcode 5 and pressing <kbd>&#x2318;</kbd> + <kbd>Shift</kbd> + <kbd>U</kbd>.

# Additional Resources

You can find additional Jawbone UP Platform documentation at <https://jawbone.com/up/platform>.

# Credits

### Development

**Andy Roth**  
Senior Software Engineer at Jawbone  
Jawbone  
