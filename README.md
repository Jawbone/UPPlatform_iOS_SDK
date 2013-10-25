# UP Platform iOS/OS X SDK

---

## Overview

This SDK provides an Objective-C interface for integrating iOS and Mac OS X apps with the [UP Platform](https://jawbone.com/up/platform). It handles authentication using OAuth 2.0 via a UIWebView and provides simple interfaces for making requests to the platform's REST endpoints.

## Installation

* Drag `UPPlatformSDK.xcodeproj` into your own xcode project or workspace.

![image](Documentation/install_1.png)

* Under Build Phases, add either `libUPPlatformSDK.a` or `libUPPlatformSDK-OSX.a` to the linked libraries, depending on your platform.

![image](Documentation/install_2.png)

* Under Build Settings, add the UPPlatformSDK (i.e. `../UPPlatformSDK/UPPlatformSDK`) directory to the Header Search Paths recursively.

![image](Documentation/install_3.png)

* Under Build Settings, add `-all_load` to Other Linker Flags.

![image](Documentation/install_4.png)

* Drag `UPPlatformSDK.bundle` into your project's resources.

![image](Documentation/install_5.png)

## Authentication

Authentication is handled using the shared `UPPlatform` object.

First, to validate that an existing session is still valid, call `validateSessionWithCompletion:`. If the `session` object passed to the completion block is not `nil`, the session is valid and API requests can be made.

*NOTE: I only added this because when requesting tokens from multiple clients (i.e. Simulator and iPhone), the previously requested tokens become invalid. We should fix this.*

To start a new session, using the `startSessionWithClientID:clientSecret:authScope:completion:` method.

	[[UPPlatform sharedPlatform] startSessionWithClientID:@"MY_CLIENT_ID" clientSecret:@"MY_CLIENT_SECRET" authScope:(UPPlatformAuthScopeExtendedRead | UPPlatformAuthScopeMoveRead) completion:^(UPSession *session, NSError *error) {
		// If session != nil we can begin making API requests.
	}];
	
See `UPPlatform.h` for all available authScopes.

## API Requests

Once a valid session has been established, there are a few ways to create API requests. You can use either the provided objects that encapsulate most of the available endpoints, or you can create custom requests.

### API Objects

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
	
## Additional Resources

You can find additional documentation at <https://jawbone.com/up/platform>.

# TODO (WIP)

## User Information

### Get detailed information about the user
### Get list of friends (identifiers)
### Get the user's current mood
### Get the user's trends

## Moves

### Get the user's move list (paginated by date or by a timestamp)
### Get the information about a specific move.
### Get the user's move graphs.
### Get move intensity.

## Workouts

### Get the user's workout list (paginated by date or by a timestamp).
### Create a new workout.
### Get information about a specific workout.
### Get the user's workout graphs.
### Get workout intensity.

## Sleeps

### Get the user's sleep list (paginated by date or by a timestamp).
### Get the information about a specific sleep.
### Get the user's sleep graphs.
### Get sleep phases.

## Meals

### Get the user's meal list (paginated by date or by a timestamp).
### Create a new meal.
### Get the information about a specific meal.

## Body Composition

### Record body weight, BMI, lean mass, and body fat.
### Retrieve user records of body weight, BMI, lean mass, and body fat.
### Get a single body composition record event.
### Delete body composition record event.

## Cardiac Metrics

### Record heart rate and blood pressure.
### Retrieve heart rate and blood pressure records.
### Get a single cardiac metric record event.
### Delete cardiac metric record event.

## Generic Events

### Create a new event that will show in the user's feed.

## Mood 

### Record the user's mood.
### Get the user's mood.
### Get a mood event.
### Delete mood event.

# Object Types

## User
## Meal
## Move
## Workout
## Sleep
## Mood
## Generic
## Cardiac
## Weight
## User Metrics
## Trends
## Timezone
