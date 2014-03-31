//
//  JBWorkoutTestViewController.m
//  APIExplorer
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBWorkoutTestViewController.h"

#import "UP.h"

@interface JBWorkoutTestViewController ()

@end

@implementation JBWorkoutTestViewController

- (void)getWorkouts
{
	[UPWorkoutAPI getWorkoutsWithLimit:14 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		[self showResults:results];
	}];
}

- (void)postWorkout
{
	NSDate *start = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] - (60 * 30)];
	NSDate *end = [NSDate date];
	
	UPWorkout *workout = [UPWorkout workoutWithType:UPWorkoutTypeRun startTime:start endTime:end intensity:UPWorkoutIntensityIntermediate caloriesBurned:@(250)];
	workout.distance = @(7);
	workout.imageURL = @"http://jaredsurnamer.files.wordpress.com/2011/11/116223-magic-marker-icon-sports-hobbies-people-man-runner.png";
	
	[UPWorkoutAPI postWorkout:workout completion:^(UPWorkout *workout, UPURLResponse *response, NSError *error) {
		[self showResults:workout];
	}];
}

- (void)updateWorkout
{
    [UPWorkoutAPI getWorkoutsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
            UPWorkout *workout = results[0];
            workout.totalCalories = @(900);
			
            [UPBaseEventAPI updateEvent:workout completion:^(id result, UPURLResponse *response, NSError *error) {
                [self showResults:result];
            }];
		}
	}];
}

- (void)refreshWorkout
{
	[UPWorkoutAPI getWorkoutsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPWorkoutAPI refreshWorkout:results[0] completion:^(UPWorkout *workout, UPURLResponse *response, NSError *error) {
				[self showResults:workout];
			}];
		}
	}];
}

- (void)deleteWorkout
{
	[UPWorkoutAPI getWorkoutsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPWorkoutAPI deleteWorkout:results[0] completion:^(id result, UPURLResponse *response, NSError *error) {
				[self showResults:response.metadata];
			}];
		}
	}];
}

- (void)getWorkoutGraphImage
{
	[UPWorkoutAPI getWorkoutsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPWorkout *workout = results[0];
			
			[UPWorkoutAPI getWorkoutGraphImage:workout completion:^(UIImage *image) {
				UIViewController *blank = [[UIViewController alloc] init];
				[self.navigationController pushViewController:blank animated:YES];
				
				UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
				[blank.view addSubview:imageView];
			}];
		}
	}];
}

- (void)getWorkoutTicks
{
	[UPWorkoutAPI getWorkoutsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPWorkout *workout = results[0];
			
			[UPWorkoutAPI getWorkoutTicks:workout completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
                [self showResults:results];
            }];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getWorkouts];
			break;
			
		case 1:
			[self postWorkout];
			break;
            
        case 2:
			[self updateWorkout];
			break;
			
		case 3:
			[self refreshWorkout];
			break;
			
		case 4:
			[self deleteWorkout];
			break;
			
		case 5:
			[self getWorkoutGraphImage];
			break;
			
		case 6:
			[self getWorkoutTicks];
			break;
			
		default:
			break;
	}
}

@end
