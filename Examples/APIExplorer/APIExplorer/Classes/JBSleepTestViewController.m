//
//  JBSleepTestViewController.m
//  APIExplorer
//
//  Created by Andy Roth on 5/31/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBSleepTestViewController.h"

#import "UP.h"

@interface JBSleepTestViewController ()

@end

@implementation JBSleepTestViewController

- (void)getSleeps
{
	[UPSleepAPI getSleepsWithLimit:14 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		[self showResults:results];
	}];
}

- (void)postSleep
{
	NSDate *start = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] - (60 * 90)];
	NSDate *end = [NSDate date];
	
	UPSleep *sleep = [UPSleep sleepWithStartTime:start endTime:end];
	[UPSleepAPI postSleep:sleep completion:^(UPSleep *sleep, UPURLResponse *response, NSError *error) {
		[self showResults:sleep];
	}];
}

- (void)refreshSleep
{
	[UPSleepAPI getSleepsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPSleepAPI refreshSleep:results[0] completion:^(UPSleep *sleep, UPURLResponse *response, NSError *error) {
				[self showResults:sleep];
			}];
		}
	}];
}

- (void)deleteSleep
{
	[UPSleepAPI getSleepsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPSleepAPI deleteSleep:results[0] completion:^(id result, UPURLResponse *response, NSError *error) {
				[self showResults:response.metadata];
			}];
		}
	}];
}

- (void)getSleepGraphImage
{
	[UPSleepAPI getSleepsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPSleep *sleep = results[0];
			
			[UPSleepAPI getSleepGraphImage:sleep completion:^(UIImage *image) {
				UIViewController *blank = [[UIViewController alloc] init];
				[self.navigationController pushViewController:blank animated:YES];
				
				UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
				[blank.view addSubview:imageView];
			}];
		}
	}];
}

- (void)getSleepSnapshot
{
	[UPSleepAPI getSleepsWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPSleep *sleep = results[0];
			
			[UPSleepAPI getSleepSnapshot:sleep completion:^(UPSnapshot *snapshot, UPURLResponse *response, NSError *error) {
				[self showResults:snapshot];
			}];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getSleeps];
			break;
			
		case 1:
			[self postSleep];
			break;
			
		case 2:
			[self refreshSleep];
			break;
			
		case 3:
			[self deleteSleep];
			break;
			
		case 4:
			[self getSleepGraphImage];
			break;
			
		case 5:
			[self getSleepSnapshot];
			break;
			
		default:
			break;
	}
}

@end
